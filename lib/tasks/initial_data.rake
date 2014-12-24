namespace :choc do

  # RAILS_ENV=testing rake choc:initial_setup
  task :initial_setup => :environment do
    if Role.count == 0
      role = Role.new(role_description: "Super Admin")
      role.save

      role = Role.new(role_description: "Admin User")
      role.save

      role = Role.new(role_description: "App User")
      role.save
    end

    if User.count == 0
      user = User.new(first_name: "Choc", last_name: "Consent", email: "choc@weboapps.com", password: "choc1234", role_id: Role.where(:role_description=> "Super Admin").first.id)
      user.is_active = true
      user.is_app_user = true
      user.is_deleted = false
      user.save
    end

    if Release.count == 0
    release = Release.new(version: 1,
                          english_desc: "<p><strong>RELEASE FORM</strong></p>
<p>I hereby consent to be photographed/videotaped while receiving treatment at the hospital. The term &ldquo;photograph&rdquo; includes video or still photography, in digital or any other format, and any other means of recording or reproducing images and/or audio.</p>
<p>I hereby authorize the use or disclosure of the photograph(s) for the following uses or purposes</p>
<p>I consent to be photographed and authorize the use or disclosure of such photograph(s) in order to assist scientific, treatment, educational, public relations, marketing, news media, and charitable goals, and I hereby waive any right to compensation for such uses by reason of the foregoing authorization. I and my successors or assigns hereby hold the hospital, its employees, my physician(s), and any other person participating in my care and their successors and assigns harmless from and against any claim for injury or compensation resulting from the activities authorized by this agreement.</p>
<p>&nbsp;</p>
<p><strong>EXPIRATION</strong></p>
<p>Upon expiration of this Authorization, this hospital will not permit further release of any photograph, but will not be able to call back any photographs or information already released.</p>
<p>&nbsp;</p>
<p><strong>YOUR RIGHTS</strong></p>
<p>I may request cessation of filming or recording at any time.</p>
<p>I may revoke this Authorization, but I must do so in writing and submit it to the following address:<br />CHOC Children&rsquo;s 455 South Main Street&nbsp;Orange CA 92868 Attention: Public Relations Department</p>
<p>My revocation will take effect upon receipt, except to the extent that others have acted in reliance upon this Authorization.</p>
<p>I may inspect or obtain a copy of the photograph whose use or disclosure I am authorizing.</p>
<p>I may refuse to sign this Authorization. My refusal will not affect my ability to obtain treatment or payment or eligibility for benefits.</p>
<p>I have a right to receive a copy of this Authorization.</p>
<p>Information disclosed pursuant to this Authorization could be re-disclosed by the recipient. Such re-disclosure is in some cases not protected by California law and may no longer be protected by federal confidentiality law (HIPAA).</p>
<p>I understand that I will not receive any financial compensation.</p>
<p>The hospital may receive compensation for the use or disclosure of my photograph(s).</p>
<p>I waive any liability and hold CHOC harmless from any injury which may result from participation in the photography/video production.</p>",
                          spanish_desc: "<p><strong>Release Tipo</strong></p>
<p>Doy mi consentimiento para ser fotografiado / filmado mientras recibe tratamiento en el hospital. El t&eacute;rmino \"fotograf&iacute;a\" incluye video o fotograf&iacute;a, en formato digital o en cualquier otro formato , y cualquier otro medio de grabaci&oacute;n o reproducci&oacute;n de im&aacute;genes y / o audio .</p>
<p>Yo autorizo ??el uso o la divulgaci&oacute;n de la fotograf&iacute;a ( s ) para los siguientes usos o fines</p>
<p>Doy mi consentimiento para ser fotografiado y autorizar el uso o divulgaci&oacute;n de dicha fotograf&iacute;a ( s ) con el fin de ayudar a los cient&iacute;ficos , el tratamiento, la educaci&oacute;n , las relaciones p&uacute;blicas , marketing, medios de comunicaci&oacute;n, y los objetivos de caridad , y por la presente renuncia a cualquier derecho de compensaci&oacute;n por tales usos por la raz&oacute;n de la autorizaci&oacute;n anterior . Yo y mis sucesores o cesionarios presente sostengo el hospital, sus empleados, mi m&eacute;dico ( s ) , y cualquier otra persona que participe en mi cuidado y sus sucesores y cesionarios de y contra cualquier reclamaci&oacute;n por da&ntilde;os o indemnizaciones que resulten de las actividades autorizadas por el presente acuerdo.</p>
<p>&nbsp;</p>
<p><strong>VENCIMIENTO</strong></p>
<p>A la expiraci&oacute;n de esta autorizaci&oacute;n , el hospital no permitir&aacute; que una mayor liberaci&oacute;n de cualquier fotograf&iacute;a , pero no ser&aacute; capaz de volver a llamar las fotograf&iacute;as y la informaci&oacute;n que ya han sido despachados .</p>
<p>&nbsp;</p>
<p><strong>SUS DERECHOS</strong></p>
<p>Puedo solicitar la cesaci&oacute;n de la filmaci&oacute;n o grabaci&oacute;n en cualquier momento.</p>
<p>Puedo revocar esta autorizaci&oacute;n , pero tengo que hacerlo por escrito y enviarlo a la siguiente direcci&oacute;n :</p>
<p>455 South Main Street Orange CA 92868 Atenci&oacute;n de CHOC Children : Departamento de Relaciones P&uacute;blicas</p>
<p>Mi revocaci&oacute;n entrar&aacute; en efecto a partir de su recepci&oacute;n, salvo en la medida en que otros han actuado basados ??en esta Autorizaci&oacute;n.</p>
<p>Puedo inspeccionar u obtener una copia de la fotograf&iacute;a cuyo uso o divulgaci&oacute;n no estoy autorizando .</p>
<p>Puedo negarme a firmar esta autorizaci&oacute;n . Mi negativa no afectar&aacute; mi capacidad de obtener tratamiento o pago o elegibilidad para beneficios.</p>
<p>Tengo derecho a recibir una copia de esta Autorizaci&oacute;n.</p>
<p>Informaci&oacute;n divulgada de conformidad con esta autorizaci&oacute;n puede ser divulgada por el destinatario. Esta nueva revelaci&oacute;n es que en algunos casos no est&aacute;n protegidos por la ley de California y puede ya no estar protegida por la ley de confidencialidad federal ( HIPAA) .</p>
<p>Entiendo que no recibir&eacute; ninguna compensaci&oacute;n econ&oacute;mica.</p>
<p>El hospital puede recibir una compensaci&oacute;n por el uso o divulgaci&oacute;n de mi fotograf&iacute;a ( s ) .</p>
<p>Renuncio a cualquier responsabilidad y sostengo CHOC libre de cualquier da&ntilde;o que pueda resultar de la participaci&oacute;n en la fotograf&iacute;a / producci&oacute;n de v&iacute;deo.</p>")

    release.save
    end

    if Use.count == 0
      u = Use.new(description: "Marketing")
      u.is_deleted = false
      u.save

      u = Use.new(description: "Educational")
      u.is_deleted = false
      u.save

      u = Use.new(description: "Treatment")
      u.is_deleted = false
      u.save
    end

    puts "\n\n****** DONE ******\n\n"
  end
end