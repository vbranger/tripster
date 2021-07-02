import flatpickr from "flatpickr";
import rangePlugin from "flatpickr/dist/plugins/rangePlugin";
import { French } from "flatpickr/dist/l10n/fr.js"

const initFlatpickr = () => {
  flatpickr("#range_start", {
    altInput: true,
    inline: true,
    class: "datepicker",
    altInputClass: "invisible d-none",
    minDate: "today",
    plugins: [new rangePlugin({ input: "#range_end"})],
    // locale: French,
  });
}

export { initFlatpickr };