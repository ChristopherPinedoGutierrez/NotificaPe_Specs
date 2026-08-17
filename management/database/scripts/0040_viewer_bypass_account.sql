-- Script: 0040_viewer_bypass_account.sql
-- App Origen: viewer
-- Autor: AGENT_ROLE
-- Fecha: 2026-08-17
-- Justificación: Creación de cuenta bypass "google-review@notificape.pe" para superar el flujo de 
-- Login en la Google Play Console, vinculándolo de antemano al dispositivo de prueba "Google Play Test".

DO $$
DECLARE
    new_user_id UUID := gen_random_uuid();
    target_dispositivo_id UUID := 'fb4ad328-6987-4730-9339-0f32b1086adf';
BEGIN
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'google-review@notificape.pe') THEN
        INSERT INTO auth.users (
            id, 
            instance_id, 
            email, 
            encrypted_password, 
            email_confirmed_at, 
            created_at, 
            updated_at, 
            raw_app_meta_data, 
            raw_user_meta_data,
            is_super_admin,
            role,
            aud,
            confirmation_token,
            recovery_token,
            email_change_token_new,
            email_change
        ) VALUES (
            new_user_id,
            '00000000-0000-0000-0000-000000000000',
            'google-review@notificape.pe',
            crypt('ReviewGoogle2026!', gen_salt('bf')),
            now(),
            now(),
            now(),
            '{"provider":"email","providers":["email"]}',
            '{}',
            false,
            'authenticated',
            'authenticated',
            '',
            '',
            '',
            ''
        );
    END IF;

    -- Extraemos el ID real por si ya existía para evitar errores
    SELECT id INTO new_user_id FROM auth.users WHERE email = 'google-review@notificape.pe';

    -- Insertar la identidad del proveedor de correo para evitar el error "Invalid login credentials"
    IF NOT EXISTS (SELECT 1 FROM auth.identities WHERE provider_id = new_user_id::text) THEN
        INSERT INTO auth.identities (
            id,
            provider_id,
            user_id,
            identity_data,
            provider,
            created_at,
            updated_at
        ) VALUES (
            gen_random_uuid(),
            new_user_id::text,
            new_user_id,
            jsonb_build_object('sub', new_user_id::text, 'email', 'google-review@notificape.pe', 'email_verified', true),
            'email',
            now(),
            now()
        );
    END IF;

    -- 2. Insertar en la tabla pública de Usuarios (Perfil)
    IF NOT EXISTS (SELECT 1 FROM public."Usuarios" WHERE "IdUsuario" = new_user_id) THEN
        INSERT INTO public."Usuarios" (
            "IdUsuario",
            "IdRol",
            "NombreCompleto",
            "Correo",
            "TelefonoUsuario",
            "EquipoMarca",
            "EquipoModelo",
            "FechaCreacion"
        ) VALUES (
            new_user_id,
            1, -- El app frontend requiere estrictamente IdRol = 1 para dejar pasar al dashboard
            'Revisor Google Play',
            'google-review@notificape.pe',
            '000000000',
            'Google',
            'Test Lab',
            now()
        );
    END IF;

    -- 3. Vincular el usuario al dispositivo de prueba (Google Play Test)
    IF NOT EXISTS (SELECT 1 FROM public."AutorizacionesXUsuario" WHERE "IdUsuario" = new_user_id AND "IdDispositivo" = target_dispositivo_id) THEN
        INSERT INTO public."AutorizacionesXUsuario" (
            "IdUsuario",
            "IdDispositivo",
            "IdEstadoAuth", -- 2 = Aprobado
            "Observacion"
        ) VALUES (
            new_user_id,
            target_dispositivo_id,
            2,
            'Auto-aprobado para revisión de Google Play'
        );
    END IF;

    RAISE NOTICE 'Cuenta bypass creada y vinculada correctamente: %', new_user_id;
END $$;
