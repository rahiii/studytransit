import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="lock-timer"
export default class extends Controller {
  static targets = [
    "durationInput",
    "durationLabel",
    "timeDisplay",
    "progressRing",
    "surveyModal",
    "roomList",
    "searchInput",
    "ratingPanel",
    "selectedRoomLabel",
    "surveyFeedback",
    "ratingSlider",
    "selectedRatingLabel",
    "lockButton",
    "resetButton",
    "surveyButton"
  ]

  static values = {
    spaces: Array,
    ratingUrl: String
  }

  connect() {
    this.timerState = "idle"
    this.selectedSpaceId = null
    this.filteredSpaces = this.spacesValue || []
    this.intervalId = null
    this.pendingRating = 3

    this.totalSeconds = this.currentMinutes * 60
    this.remainingSeconds = this.totalSeconds

    this.configureRing()
    this.updateTimeDisplay()
    this.renderRoomList()
  }

  disconnect() {
    this.clearTimer()
  }

  get currentMinutes() {
    return parseInt(this.durationInputTarget?.value || "60", 10)
  }

  configureRing() {
    if (!this.hasProgressRingTarget) return

    const radius = parseFloat(this.progressRingTarget.getAttribute("r"))
    this.circumference = 2 * Math.PI * radius
    this.progressRingTarget.style.strokeDasharray = `${this.circumference} ${this.circumference}`
    this.updateProgress(0)
  }

  updateDuration() {
    const minutes = this.currentMinutes
    if (this.hasDurationLabelTarget) {
      this.durationLabelTarget.textContent = `${minutes} minutes`
    }

    if (this.timerState === "idle") {
      this.totalSeconds = minutes * 60
      this.remainingSeconds = this.totalSeconds
      this.updateTimeDisplay()
      this.updateProgress(0)
    }
  }

  toggleTimer() {
    if (this.timerState === "running") return
    if (this.timerState === "completed") {
      this.resetTimer()
    }
    this.startTimer()
  }

  startTimer() {
    if (this.timerState === "running") return

    this.timerState = "running"
    this.remainingSeconds = this.totalSeconds
    this.updateTimeDisplay()
    this.updateProgress(0)
    this.durationInputTarget.disabled = true
    this.lockButtonTarget.textContent = "LOCKED..."
    this.lockButtonTarget.classList.add("is-active")
    this.lockButtonTarget.disabled = true
    this.resetButtonTarget.classList.remove("hidden")
    this.resetButtonTarget.textContent = "Cancel session"
    this.setFeedback("")

    this.intervalId = window.setInterval(() => this.tick(), 1000)
  }

  tick() {
    if (this.remainingSeconds <= 0) {
      this.finishTimer()
      return
    }

    this.remainingSeconds -= 1
    this.updateTimeDisplay()

    if (this.totalSeconds > 0) {
      const progress = 1 - this.remainingSeconds / this.totalSeconds
      this.updateProgress(progress)
    }
  }

  finishTimer() {
    this.clearTimer()
    this.timerState = "completed"
    this.remainingSeconds = 0
    this.updateTimeDisplay()
    this.updateProgress(1)

    this.lockButtonTarget.textContent = "Session complete!"
    this.lockButtonTarget.disabled = true
    this.resetButtonTarget.classList.remove("hidden")
    this.resetButtonTarget.textContent = "Start another session"

    this.setFeedback("Nice work! Your focus session is complete.", "success")
  }

  resetTimer() {
    this.clearTimer()
    this.timerState = "idle"
    this.lockButtonTarget.textContent = "LOCK IN!"
    this.lockButtonTarget.classList.remove("is-active")
    this.lockButtonTarget.disabled = false
    this.durationInputTarget.disabled = false
    this.resetButtonTarget.classList.add("hidden")
    this.updateDuration()
    this.setFeedback("")
  }

  clearTimer() {
    if (this.intervalId) {
      window.clearInterval(this.intervalId)
      this.intervalId = null
    }
  }

  updateTimeDisplay() {
    if (!this.hasTimeDisplayTarget) return

    const minutes = Math.floor(this.remainingSeconds / 60)
    const seconds = this.remainingSeconds % 60
    this.timeDisplayTarget.textContent = `${this.pad(minutes)}:${this.pad(seconds)}`
  }

  updateProgress(progress = 0) {
    if (!this.hasProgressRingTarget || !this.circumference) return

    const clamped = Math.min(Math.max(progress, 0), 1)
    const offset = this.circumference * (1 - clamped)
    this.progressRingTarget.style.strokeDashoffset = offset
  }

  pad(value) {
    return String(value).padStart(2, "0")
  }

  // Survey modal controls
  openSurvey() {
    if (!this.hasSurveyModalTarget) return
    this.element.classList.add("survey-open")
    this.surveyModalTarget.classList.remove("hidden")
    this.filteredSpaces = this.spacesValue || []
    this.renderRoomList()
    this.ratingPanelTarget?.classList.add("hidden")
    this.pendingRating = 3
    if (this.hasRatingSliderTarget) {
      this.ratingSliderTarget.value = this.pendingRating
      this.updateRatingPreview()
    }
    this.selectedSpaceId = null
    if (this.hasSearchInputTarget) {
      this.searchInputTarget.value = ""
      window.setTimeout(() => this.searchInputTarget.focus(), 150)
    }
  }

  closeSurvey() {
    if (!this.hasSurveyModalTarget) return
    this.surveyModalTarget.classList.add("hidden")
    this.element.classList.remove("survey-open")
  }

  skipSurvey() {
    this.setFeedback("Survey skipped. You can always update the room later.")
    this.closeSurvey()
  }

  filterRooms() {
    const term = (this.searchInputTarget?.value || "").trim().toLowerCase()
    const spaces = this.spacesValue || []

    if (term.length === 0) {
      this.filteredSpaces = spaces
    } else {
      this.filteredSpaces = spaces.filter((space) => {
        return (
          (space.name && space.name.toLowerCase().includes(term)) ||
          (space.library && space.library.toLowerCase().includes(term))
        )
      })
    }

    this.renderRoomList()
  }

  clearSearch() {
    if (!this.hasSearchInputTarget) return
    this.searchInputTarget.value = ""
    this.filterRooms()
  }

  renderRoomList() {
    if (!this.hasRoomListTarget) return

    this.roomListTarget.innerHTML = ""
    if (!this.filteredSpaces || this.filteredSpaces.length === 0) {
      const placeholder = document.createElement("li")
      placeholder.className = "survey-room-empty"
      placeholder.textContent = "No rooms match your search yet."
      this.roomListTarget.appendChild(placeholder)
      return
    }

    this.filteredSpaces.forEach((space) => {
      const item = document.createElement("li")
      item.className = "survey-room-item"
      item.dataset.spaceId = space.id
      item.dataset.action = "click->lock-timer#selectRoom"

      const name = document.createElement("span")
      name.className = "survey-room-name"
      name.textContent = space.name

      const library = document.createElement("span")
      library.className = "survey-room-library"
      library.textContent = space.library || "Unknown library"

      item.appendChild(name)
      item.appendChild(library)
      this.roomListTarget.appendChild(item)
    })
  }

  selectRoom(event) {
    const element = event.currentTarget
    this.selectedSpaceId = element.dataset.spaceId

    this.roomListTarget
      .querySelectorAll(".survey-room-item.is-selected")
      .forEach((item) => item.classList.remove("is-selected"))
    element.classList.add("is-selected")

    if (this.hasSelectedRoomLabelTarget) {
      const name = element.querySelector(".survey-room-name")?.textContent
      const library = element.querySelector(".survey-room-library")?.textContent
      this.selectedRoomLabelTarget.textContent = `${name} • ${library}`
    }

    this.ratingPanelTarget?.classList.remove("hidden")
    this.pendingRating = parseInt(this.ratingSliderTarget?.value || "3", 10)
    this.updateRatingPreview()
  }

  updateRatingPreview() {
    if (!this.hasRatingSliderTarget) return
    this.pendingRating = parseInt(this.ratingSliderTarget.value, 10)
    if (this.hasSelectedRatingLabelTarget) {
      this.selectedRatingLabelTarget.textContent = `${this.pendingRating} / 5`
    }
  }

  async submitRating() {
    if (!this.selectedSpaceId) {
      this.setFeedback("Please choose a room before rating.", "error")
      return
    }

    const value = this.pendingRating
    if (!Number.isFinite(value)) return

    try {
      const response = await fetch(this.ratingUrlValue, {
        method: "POST",
        headers: this.requestHeaders(),
        body: JSON.stringify({
          space_id: this.selectedSpaceId,
          value
        })
      })

      const payload = await response.json()
      if (response.ok && payload.status === "ok") {
        this.setFeedback("Thanks for the update! The room rating has been refreshed.", "success")
        this.surveyButtonTarget.textContent = "Thanks for rating!"
        this.surveyButtonTarget.classList.add("is-complete")
        this.closeSurvey()
      } else {
        const message = payload.errors?.join(", ") || "Unable to save rating."
        this.setFeedback(message, "error")
      }
    } catch (error) {
      this.setFeedback("Something went wrong. Please try again.", "error")
    }
  }

  requestHeaders() {
    const headers = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }
    const csrfToken = document.querySelector("meta[name='csrf-token']")?.content
    if (csrfToken) headers["X-CSRF-Token"] = csrfToken
    return headers
  }

  setFeedback(message, status = null) {
    if (!this.hasSurveyFeedbackTarget) return
    this.surveyFeedbackTarget.textContent = message
    this.surveyFeedbackTarget.dataset.status = status || ""
    if (message) {
      this.surveyFeedbackTarget.classList.add("is-visible")
    } else {
      this.surveyFeedbackTarget.classList.remove("is-visible")
    }
  }
}

