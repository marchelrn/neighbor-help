package handler

import (
	"net/http"
	"strconv"

	"neighbor_help/contract"
	"neighbor_help/dto"

	"github.com/gin-gonic/gin"
)
type HelpRequestHandler struct {
	Service contract.HelpRequestService
}

func NewHelpRequestHandler(
	service contract.HelpRequestService,
) *HelpRequestHandler {

	return &HelpRequestHandler{
		Service: service,
	}
}

// =========================
// CREATE HELP REQUEST
// =========================

func (h *HelpRequestHandler) CreateHelpRequest(
	c *gin.Context,
) {

	var req dto.CreateHelpRequestRequest

	if err := c.ShouldBindJSON(&req); err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"status": 400,
			"message": err.Error(),
		})

		return
	}

	payload := &dto.HelpRequest{
		Title:       req.Title,
		Description: req.Description,
		Category:    req.Category,
		Latitude:    req.Latitude,
		Longitude:   req.Longitude,
	}

	userID := c.GetUint("user_id")

	response, err := h.Service.CreateHelpRequest(
		userID,
		payload,
	)

	if err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"status": 400,
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusCreated, response)
}

// =========================
// GET ALL HELP REQUESTS
// =========================

func (h *HelpRequestHandler) GetAllHelpRequests(
	c *gin.Context,
) {

	helpRequests, err :=
		h.Service.GetAllHelpRequests()

	if err != nil {

		c.JSON(http.StatusInternalServerError, gin.H{
			"status": 500,
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status": 200,
		"help_requests": helpRequests,
	})
}

// =========================
// GET NEARBY HELP REQUESTS
// =========================

func (h *HelpRequestHandler) GetNearbyHelpRequests(
	c *gin.Context,
) {

	var req dto.GetNearbyHelpRequestsRequest

	if err := c.ShouldBindQuery(&req); err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"status": 400,
			"message": err.Error(),
		})

		return
	}

	userID := c.GetUint("user_id")

	helpRequests, err := h.Service.GetNearbyHelpRequests(
		req.Latitude,
		req.Longitude,
		userID,
		req.RadiusMeters,
	)

	if err != nil {

		c.JSON(http.StatusInternalServerError, gin.H{
			"status": 500,
			"message": err.Error(),
		})

		return
	}

	

	c.JSON(http.StatusOK, gin.H{
		"status": 200,
		"help_requests": helpRequests,
	})
}

// =========================
// GET HELP REQUEST BY ID
// =========================

func (h *HelpRequestHandler) GetHelpRequestByID(
	c *gin.Context,
) {

	id, err := strconv.Atoi(
		c.Param("id"),
	)

	if err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"status": 400,
			"message": "invalid id",
		})

		return
	}

	helpRequest, err :=
		h.Service.GetHelpRequestByID(
			uint(id),
		)

	if err != nil {

		c.JSON(http.StatusNotFound, gin.H{
			"status": 404,
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status": 200,
		"help_request": helpRequest,
	})
}

// =========================
// GET MY HELP REQUESTS
// =========================

func (h *HelpRequestHandler) GetHelpRequestByUserID(
	c *gin.Context,
) {

	userID := c.GetUint("user_id")

	helpRequests, err :=
		h.Service.GetHelpRequestByUserID(
			userID,
		)

	if err != nil {

		c.JSON(http.StatusInternalServerError, gin.H{
			"status": 500,
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status": 200,
		"help_requests": helpRequests,
	})
}

// =========================
// DELETE HELP REQUEST
// =========================

func (h *HelpRequestHandler) DeleteHelpRequest(
	c *gin.Context,
) {

	id, err := strconv.Atoi(
		c.Param("id"),
	)

	if err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"status": 400,
			"message": "invalid id",
		})

		return
	}

	userID := c.GetUint("user_id")

	err = h.Service.DeleteHelpRequest(
		userID,
		uint(id),
	)

	if err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"status": 400,
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status": 200,
		"message": "Help request deleted successfully",
	})


	
	
}

// =========================
// UPDATE HELP REQUEST
// =========================

func (h *HelpRequestHandler) UpdateHelpRequest(
	c *gin.Context,
) {

	id, err := strconv.Atoi(
		c.Param("id"),
	)

	if err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"status": 400,
			"message": "invalid id",
		})

		return
	}

	var req dto.UpdateHelpRequestRequest

	if err := c.ShouldBindJSON(&req); err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"status": 400,
			"message": err.Error(),
		})

		return
	}

	userID := c.GetUint("user_id")

	err = h.Service.UpdateHelpRequest(
		userID,
		uint(id),
		&req,
	)

	if err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"status": 400,
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status": 200,
		"message": "Help request updated successfully",
	})
}