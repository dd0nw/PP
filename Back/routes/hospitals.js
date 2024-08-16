const express = require('express');
const axios = require('axios');
require('dotenv').config();

const router = express.Router();

const GOOGLE_API_KEY = process.env.GOOGLE_API_KEY;
const PLACES_API_URL = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

if (!GOOGLE_API_KEY) {
    process.exit(1);
}

router.get('/hospitals', async (req, res) => {

    const { latitude, longitude } = req.query;


    if (!latitude || !longitude) {
        return res.status(400).send('Latitude and longitude are required');
    }

    const lat = parseFloat(latitude);
    const lon = parseFloat(longitude);

    if (isNaN(lat) || isNaN(lon)) {
        return res.status(400).send('Invalid latitude or longitude');
    }


    try {
        const queryParams = new URLSearchParams({
            location: `${lat},${lon}`,
            radius: '5000', // 반경을 5킬로미터로 설정
            type: 'hospital',
            key: GOOGLE_API_KEY
        });

        const apiUrl = `${PLACES_API_URL}?${queryParams.toString()}`;

        const response = await axios.get(apiUrl, { timeout: 30000 }); // 30초

        if (!response.data.results || response.data.results.length === 0) {
            return res.status(404).send('No hospitals found');
        }


        const hospitals = response.data.results.map(result => ({
            name: result.name,
            address: result.vicinity,
            place_id: result.place_id,
            geometry: {
                location: {
                    lat: result.geometry.location.lat,
                    lng: result.geometry.location.lng
                }
            }
        }));


        return res.status(200).json(hospitals);
    } catch (error) {
        if (error.code === 'ETIMEDOUT') {
            return res.status(504).send('Gateway Timeout');
        }
        return res.status(500).send('Internal Server Error');
    }
});

module.exports = router;
