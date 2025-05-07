document.addEventListener('DOMContentLoaded', () => {
    // Referências aos elementos do DOM
    const dateInput = document.getElementById('appointment-date');
    const timeSelect = document.getElementById('appointment-time');
    const nameInput = document.getElementById('patient-name');
    const phoneInput = document.getElementById('patient-phone');
    const emailInput = document.getElementById('patient-email');
    const scheduleButton = document.getElementById('schedule-btn');
    const confirmationMessageDiv = document.getElementById('confirmation-message');

    // Array de horários disponíveis (para qualquer data)
    const availableTimes = [
        "08:00", "09:00", "10:00", "11:00",
        "14:00", "15:00", "16:00", "17:00"
    ];

    // Função para popular o select de horários
    function populateTimes() {
        // Limpa as opções atuais (exceto a primeira "Selecione uma data")
        while (timeSelect.options.length > 1) {
            timeSelect.remove(1);
        }

        // Se uma data foi selecionada, habilita e popula o select
        if (dateInput.value) {
            timeSelect.disabled = false;
            availableTimes.forEach(time => {
                const option = document.createElement('option');
                option.value = time;
                option.textContent = time;
                timeSelect.appendChild(option);
            });
        } else {
            // Se a data for removida, desabilita e reseta o select
            timeSelect.disabled = true;
             const defaultOption = document.createElement('option');
             defaultOption.value = "";
             defaultOption.textContent = "Selecione uma data primeiro";
             timeSelect.appendChild(defaultOption);
             timeSelect.value = ""; // Resetar para a opção padrão
        }
    }

    // Função para validar os campos do formulário
    function validateForm() {
        if (!dateInput.value) {
            alert("Por favor, selecione uma data.");
            return false;
        }
         if (!timeSelect.value) {
             alert("Por favor, selecione um horário.");
             return false;
         }
        if (!nameInput.value.trim()) {
            alert("Por favor, insira seu nome.");
            return false;
        }
        if (!phoneInput.value.trim()) {
            alert("Por favor, insira seu telefone.");
            return false;
        }
        if (!emailInput.value.trim()) {
            alert("Por favor, insira seu e-mail.");
            return false;
        }
        // Adicionar validação de formato de email/telefone
        return true;
    }

    // Função botão de agendar
    function handleScheduleClick() {
        if (validateForm()) {
            // Coleta as informações do agendamento
            const selectedDate = dateInput.value;
            const selectedTime = timeSelect.value;
            const patientName = nameInput.value.trim();
            const patientPhone = phoneInput.value.trim();
            const patientEmail = emailInput.value.trim();

            // Mensagem de confirmação
            const confirmationHTML = `
                <p><strong>Agendamento Confirmado!</strong></p>
                <p><strong>Data:</strong> ${selectedDate}</p>
                <p><strong>Horário:</strong> ${selectedTime}</p>
                <p><strong>Paciente:</strong> ${patientName}</p>
                <p><strong>Telefone:</strong> ${patientPhone}</p>
                <p><strong>E-mail:</strong> ${patientEmail}</p>
                <p>Aguarde a confirmação final da clínica por e-mail ou telefone.</p>
            `;

            // Exibe a mensagem de confirmação
            confirmationMessageDiv.innerHTML = confirmationHTML;
            confirmationMessageDiv.style.display = 'block';

            // Limpar o formulário após o agendamento
            // dateInput.value = '';
            // timeSelect.value = ''; // Pode ser necessário resetar a lista ou desabilitar novamente
            // nameInput.value = '';
            // phoneInput.value = '';
            // emailInput.value = '';
             // populateTimes(); // Chamar para resetar a lista de horários

             // Em um sistema real, aqui enviaria os dados para o backend
             console.log("Dados enviados para simulação:", {
                 data: selectedDate,
                 horario: selectedTime,
                 nome: patientName,
                 telefone: patientPhone,
                 email: patientEmail
             });
        }
    }

    // Adiciona os listeners de eventos
    dateInput.addEventListener('change', populateTimes);
    scheduleButton.addEventListener('click', handleScheduleClick);

    // Inicializa o select dos horários (desabilitado até uma data ser escolhida)
    populateTimes();
});