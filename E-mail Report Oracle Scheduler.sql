CREATE OR REPLACE PROCEDURE send_max_date_email AS
BEGIN
    DECLARE
        max_date DATE;
        email_subject VARCHAR2(100) := 'Günlük Max Tarih Raporu';
        email_body CLOB := '';
    BEGIN
        -- En son tarihi al
        SELECT MAX(AS_OF_DT) INTO max_date FROM dm.vg_lorem_ipsum;

        -- E-posta içeriği oluşturma
        email_body := 'Bugünkü en son tarih: ' || TO_CHAR(max_date, 'YYYY-MM-DD');

        -- E-posta gönderme
        UTL_MAIL.send(
            sender     => 'gönderen@email.com',
            recipients => 'alıcı@email.com',
            subject    => email_subject,
            message    => email_body
        );
    EXCEPTION
        WHEN OTHERS THEN
            -- Hata durumunda loglama veya başka bir işlem eklenebilir
            DBMS_OUTPUT.put_line('Hata: ' || SQLERRM);
    END;
END send_max_date_email;
/



-- Oracle Scheduler Görevini Planlama

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'SEND_MAX_DATE_EMAIL_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN send_max_date_email; END;',
        start_date      => TRUNC(SYSDATE) + 9/24, -- Bugün saat 09:00
        repeat_interval => 'FREQ=DAILY; BYHOUR=9,16; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );
END;
/
