import {RoleEnum} from "./Enums";

export const handleHeadCells = (headCells, role, isPriceShown) => {
    const isContainVendorField = headCells.some(elem => elem.id === 'vendor');
    if(RoleEnum.Client === role && isContainVendorField) {
        headCells.splice(0,1);
    }
    const isContainPriceField = headCells.some(elem => elem.id === 'cost');
    if(!isPriceShown && isContainPriceField) {
        headCells.splice(4,1);
    } else if(!isContainPriceField) {
        headCells.splice(4,0, { id: 'cost', numeric: true, disablePadding: false, label: 'Ціна' });
    }
};