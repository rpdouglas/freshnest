// Utility to handle Google Maps Geocoding
const API_KEY = import.meta.env.VITE_GOOGLE_MAPS_API_KEY;

export const geocodeAddress = async (address) => {
  if (!address || !API_KEY) return null;

  try {
    // CORRECTED: No backslash before the backtick or ${
    const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(address)}&key=${API_KEY}`;
    const response = await fetch(url);
    const data = await response.json();

    if (data.status === 'OK' && data.results.length > 0) {
      const location = data.results[0].geometry.location;
      return {
        lat: location.lat,
        lng: location.lng
      };
    } else {
      console.warn("Geocoding failed:", data.status);
      return null;
    }
  } catch (error) {
    console.error("Geocoding error:", error);
    return null;
  }
};
