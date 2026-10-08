CREATE OR REPLACE TRIGGER trigger_actualizar_saldo_cuota
AFTER INSERT ON pago
FOR EACH ROW
EXECUTE FUNCTION actualizar_saldo_cuota();