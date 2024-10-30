import { ofetch } from "ofetch";
import camelcaseKeys from "camelcase-keys";
import { getPublicEnv } from "./helpers";

export const apiClient = ofetch.create({
  async onRequest({ options }) {
    options.baseURL = getPublicEnv("API_SERVER_URL");
  },
  parseResponse: response => {
    try {
      return camelcaseKeys(JSON.parse(response), { deep: true });
    } catch (SyntaxError) {
      return response;
    }
  },
});
