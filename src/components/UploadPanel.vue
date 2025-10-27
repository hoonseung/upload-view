<script lang="ts">
import apiClient from '@/api/client';
import {defineComponent, PropType} from 'vue'

export default defineComponent({
  name: "UploadModal",
  // 1. 부모(DataUploadHub)로부터 '어떤 카드'인지 데이터를 받음
  props: {
    cardData: {
      type: Object as PropType<CardData>,
      required: true
    }
  },

  // 2. 이 패널에서만 사용할 데이터 (멤버 변수)
  data() {
    const getTodayDateString = (): string => {
      const today = new Date(); // KST 기준 현재 날짜
      const year = today.getFullYear();
      const month = ('0' + (today.getMonth() + 1)).slice(-2);
      const day = ('0' + today.getDate()).slice(-2);
      return `${year}-${month}-${day}`;
    };

    return {
      uploadDate: getTodayDateString(),
      selectedFiles: [] as File[],
      isUploading: false
    };
  },

  // 3. 메서드
  methods: {
    // 닫기 버튼이나 뒷배경 클릭 시 부모에게 'close' 이벤트를 보냄
    closePanel() {
      // this.$emit은 Spring의 이벤트 발행과 유사합니다.
      this.$emit('close');
    },

    // '파일 선택' 버튼이 클릭되면 실행될 함수
    triggerFileInput() {
      // this.$refs.fileInputRef는 숨겨진 <input> 태그를 가리킵니다.
      // 이 코드는 숨겨진 <input>을 강제로 클릭합니다.
      (this.$refs.fileInputRef as HTMLInputElement).click();
    },

    // 파일이 실제로 선택되었을 때 실행될 함수
    handleFileSelect(event: Event) {
      const target = event.target as HTMLInputElement;
      if (target.files && target.files.length > 0) {
        // target.files는 FileList 객체입니다.
        // Array.from()을 사용해 진짜 JavaScript 배열로 변환해서 저장합니다.
        this.selectedFiles = Array.from(target.files);
      }
    },

    // '업로드 시작' 버튼이 클릭되면 실행될 함수
    async startUpload() {
      // 1. 파일이 있는지 확인
      if (this.selectedFiles.length === 0) {
        alert('파일을 먼저 선택하세요.');
        return;
      }

      this.isUploading = true; // 업로드 상태로 변경
      // 2. FormData 객체 생성 (Spring으로 파일을 보낼 때 표준)
      // Java의 'Map'처럼 데이터를 key-value로 담습니다.
      const formData = new FormData();

      // Spring @RequestParam("file") MultipartFile file 과 일치해야 함
      for (const file of this.selectedFiles) {
        if (file.name.startsWith('g-')) {
          formData.append('gFile', file);
        } else if (file.name.startsWith('d-')) {
          formData.append('dFile', file)
        } else {
          formData.append('file', file)
        }
      }
      // Spring @RequestParam("uploadDate") String date 와 일치
      formData.append('date', this.uploadDate);

      // 3. API 호출
        const url = this.cardData.apiUrl;
        await apiClient.post(url, formData)
        .then(res => {
          if (res.status === 200) {
            alert('업로드에 성공했습니다!');
            this.closePanel(); // 성공하면 패널 닫기
          } else {
            alert(`업로드 실패: ${res.data}`);
          }
        }).catch(err => {
          console.error('업로드 중 오류 발생:', err);
          alert('업로드 중 오류가 발생했습니다.');
        })
        // 성공하든 실패하든 업로드 상태 해제
        this.isUploading = false;
      }
  }
})
</script>

<template>
  <div class="panel-backdrop" @click="closePanel">

    <div class="panel-content" @click.stop>

      <header class="panel-header">
        <h2>{{ cardData.title }}</h2>
        <button class="close-btn" @click="closePanel">
          <i class="bi bi-x-lg"></i>
        </button>
      </header>

      <main class="panel-body">
        <div class="drop-zone">
          <div v-if="selectedFiles.length === 0">
            <i class="bi bi-upload upload-icon"></i>
            <p>CSV 파일만 업로드 가능</p>
            <span>'파일 선택'을 클릭하세요</span>
          </div>
          <div v-else class="file-list-container">
            <p>{{ selectedFiles.length }}개의 파일이 업로드 준비되었습니다.</p>
            <ul>
              <li v-for="file in selectedFiles" :key="file.name">
                <i class="bi bi-file-earmark-spreadsheet"></i>
                {{ file.name }} ({{ (file.size / 1024).toFixed(1) }} KB)
              </li>
            </ul>
          </div>

          <button class="select-file-btn" @click="triggerFileInput">
            <i class="bi bi-paperclip"></i> 파일 선택
          </button>

          <input
              type="file"
              ref="fileInputRef"
              @change="handleFileSelect"
              accept=".csv"
              hidden
              multiple
          />
        </div>
      </main>

      <footer class="panel-footer">
        <div class="date-input">
          <label for="upload-date">업로드 날짜</label>
          <div>
            <input type="date" id="upload-date" v-model="uploadDate"/>
          </div>
        </div>

        <button class="submit-btn" @click="startUpload" :disabled="isUploading">
          {{ isUploading ? '업로드 중...' : '업로드 시작' }}
        </button>
      </footer>
    </div>
  </div>
</template>

<style scoped>
/* 👇 여기가 핵심입니다.
  기존 <style> 내용을 모두 지우고 이 CSS로 교체하세요.
*/

/* 1. 뒷배경 (반투명) */
.panel-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.5); /* 반투명 검은색 */
  z-index: 1000;
  cursor: pointer; /* 클릭해서 닫을 수 있음을 표시 */
}

/* 2. 패널 본체 (오른쪽에서 나오는 흰색 영역) */
.panel-content {
  position: fixed;
  top: 0;
  right: 0; /* 오른쪽에 고정 */
  width: 500px; /* 패널 너비 */
  max-width: 90%; /* 모바일 화면 배려 */
  height: 100vh; /* 화면 전체 높이 */
  background-color: white;
  box-shadow: -4px 0 15px rgba(0, 0, 0, 0.15); /* 왼쪽에만 그림자 */
  z-index: 1001;
  cursor: default; /* 패널 위에서는 기본 커서 */

  /* (중요) 패널을 3개 영역(헤더, 바디, 푸터)으로 나누기 위해 flex 사용 */
  display: flex;
  flex-direction: column;
}

/* 3. 패널 내부 레이아웃 */

/* 헤더 (상단 고정) */
.panel-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #eee;
  flex-shrink: 0; /* (내용이 많아도 줄어들지 않음) */
}

.panel-header h2 {
  margin: 0;
  font-size: 18px;
  color: #333;
}

.close-btn {
  background: none;
  border: none;
  font-size: 20px; /* 아이콘 크기 */
  cursor: pointer;
  color: #888;
}

.close-btn:hover {
  color: #333;
}

.panel-tabs button.active {
  background-color: white;
  color: #333;
  font-weight: bold;
  border: 1px solid #eee;
  border-bottom: 1px solid white;
  position: relative;
  top: 1px;
}

/* 메인 컨텐츠 (남는 공간 모두 차지 + 스크롤) */
.panel-body {
  padding: 20px;
  /* (가장 중요) 남는 세로 공간을 이 영역이 모두 차지하도록 함 */
  flex-grow: 1;
  overflow-y: auto; /* 내용이 넘칠 경우 세로 스크롤 */
}

.drop-zone {
  border: 2px dashed #d0d0d0;
  border-radius: 8px;
  padding: 40px;
  text-align: center;
  background-color: #fdfdfd;
}

.drop-zone .upload-icon {
  font-size: 40px;
  color: #aaa;
}

.drop-zone p {
  font-size: 16px;
  font-weight: bold;
  color: #555;
  margin: 10px 0;
}

.drop-zone span {
  font-size: 14px;
  color: #777;
  display: block;
  margin-bottom: 20px;
}

.select-file-btn {
  background-color: white;
  border: 1px solid #ccc;
  border-radius: 6px;
  padding: 8px 16px;
  cursor: pointer;
  font-size: 14px;
  font-weight: bold;
}

.select-file-btn i {
  margin-right: 8px;
}

/* 푸터 (하단 고정) */
.panel-footer {
  padding: 20px;
  background-color: #f9fafb;
  border-top: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-shrink: 0; /* (줄어들지 않음) */
}

.date-input label {
  font-size: 14px;
  color: #555;
  display: block;
  margin-bottom: 8px;
}

.date-input div {
  display: flex;
  align-items: center;
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: white;
  padding: 0 8px;
}

.date-input i {
  color: #777;
  margin-right: 8px;
}

.date-input input {
  font-family: inherit;
  border: none;
  outline: none;
  padding: 8px 0;
  font-size: 14px;
}

.submit-btn {
  background-color: #a89eff;
  color: white;
  border: none;
  border-radius: 6px;
  padding: 12px 24px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
}

.submit-btn:hover {
  background-color: #8c7dfd;
}
</style>