import axios from 'axios';


const apiClient = axios.create(
    {
      baseURL: window.runtimeConfig.VITE_SERVER_API_URL || 'http://localhost:9898'
    }
)

export default apiClient