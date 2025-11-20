<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'DatePickerModal',
  data() {
    return {
      // [추가] 'month' (1개월) 또는 'date' (날짜 지정) 옵션을 저장
      selectedOption: 'month', // 기본값으로 '1개월'을 선택해 둡니다.

      // 날짜는 비워둡니다.
      selectedDate: '',

      today: new Date().toISOString().split('T')[0]
    }
  },
  methods: {
    onConfirm() {
      // [수정] 날짜 지정 옵션인데 날짜가 선택되지 않았으면 경고
      if (this.selectedOption === 'date' && !this.selectedDate) {
        alert('시작 날짜를 선택해 주세요.');
        return; // 함수 종료
      }

      // [추가] 혹시 모를 경우를 대비한 2차 검증
      // (max 속성이 동작 안 하는 브라우저 등)
      if (this.selectedOption === 'date' && this.selectedDate > this.today) {
        alert('시작 날짜는 오늘(' + this.today + ')보다 미래일 수 없습니다.');
        return;
      }

      // [수중] 부모에게 '옵션'과 '날짜'를 객체로 묶어 전달
      this.$emit('confirm', {
        option: this.selectedOption, // 'month' 또는 'date'
        date: this.selectedDate      // 날짜 값 (없으면 '')
      })
    },
    onClose() {
      this.$emit('close')
    }
  }
})
</script>

<template>
  <div class="modal-backdrop" @click.self="onClose">
    <div class="modal-content">

      <p>갱신할 데이터 범위를 선택하세요.</p>

      <div class="option-group">
        <label>
          <input type="radio" v-model="selectedOption" value="month" />
          최근 1개월 데이터 (날짜 선택 불필요)
        </label>
        <label>
          <input type="radio" v-model="selectedOption" value="date" />
          시작 날짜 지정
        </label>
      </div>

      <input
          v-if="selectedOption === 'date'"
          type="date"
          class="date-input"
          v-model="selectedDate"

          :max="today"
      />

      <div class="modal-actions">
        <button class="btn-cancel" @click="onClose">취소</button>
        <button class="btn-confirm" @click="onConfirm">확인</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.modal-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 100;
}

.modal-content {
  background-color: white;
  border-radius: 8px;
  padding: 24px;
  width: 90%;
  max-width: 400px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

h3 {
  margin-top: 0;
  font-size: 18px;
  font-weight: bold;
}

p {
  font-size: 14px;
  color: #181818;
  margin-bottom: 20px;
}

/* [추가] 라디오 버튼 그룹 스타일 */
.option-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 20px; /* 옵션과 다음 요소(날짜입력창 또는 버튼) 사이 간격 */
}
.option-group label {
  display: flex;
  align-items: center;
  gap: 8px; /* 라디오 버튼과 텍스트 사이 간격 */
  font-size: 14px;
  cursor: pointer;
  color: #333;
}

.date-input {
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 16px;
  box-sizing: border-box;

  /* [변경] 날짜 입력창은 옵션 아래에 표시되므로 상단 마진 제거 */
  /* 대신 .modal-actions에서 상단 마진을 관리 */
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 24px;
}

button {
  border: none;
  border-radius: 6px;
  padding: 10px 16px;
  font-size: 14px;
  font-weight: bold;
  cursor: pointer;
}

.btn-cancel {
  background-color: #f0f0f0;
  color: #555;
}
.btn-cancel:hover {
  background-color: #e0e0e0;
}

.btn-confirm {
  background-color: #4a69ff;
  color: white;
}
.btn-confirm:hover {
  background-color: #3a5ae0;
}
</style>