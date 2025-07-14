Received: from mail.growora.pl (mail.growora.pl [51.254.119.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208D61C5D46
	for <linux-xfs@vger.kernel.org>; Mon, 14 Jul 2025 07:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.254.119.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752479780; cv=none; b=CZFnB65LpQA9bbegH43/I+ac3tbMgFJBO4IRakvr5RJfsy8CLsQ6BJIcqCY+sBefkiVe+s5JXBq3Ja8XTElIAKIR9ne966XrOb74n/2QTHf6+C6ze3VW7gOfJr5PU+MZQcznK20Db7RPq1aczOB4EEx5f8Qmg8fQcqMI6Or/1jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752479780; c=relaxed/simple;
	bh=RSy3akR1+Z0TK1MqUcCTAhuNDshd4oA9g7Cu4aFIABY=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=t3waEJQuAx+l+6+j2dEYZhgrAiCQSJcWIgJUZaln0LySM7IoPy6Xs8q0e6UiHItZUW+NzI5OVfWOHE9xo0mWCPaz6TB1Rg2Xcr84BJ31XKBzSUGzmdjvnCGh7CnbVU7GON9z/qCJEgrkAwPW5JO/opx2rUxr6wU89/Vb43sQ70Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=growora.pl; spf=pass smtp.mailfrom=growora.pl; dkim=pass (2048-bit key) header.d=growora.pl header.i=@growora.pl header.b=W5dH5Isq; arc=none smtp.client-ip=51.254.119.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=growora.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=growora.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=growora.pl header.i=@growora.pl header.b="W5dH5Isq"
Received: by mail.growora.pl (Postfix, from userid 1002)
	id 6068C23C0F; Mon, 14 Jul 2025 09:52:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=growora.pl; s=mail;
	t=1752479613; bh=RSy3akR1+Z0TK1MqUcCTAhuNDshd4oA9g7Cu4aFIABY=;
	h=Date:From:To:Subject:From;
	b=W5dH5IsqmG8QT++QnTSWzffV8afvnSUAfnN6ooXbpxt1P+H54+e6GBpv3DDZWcakb
	 RDHXkVwSnVo9h00UbZIndJOQ5rXNsPbvrIY3XToYV7zBzFmk1AxQZVabYSjydJ26E2
	 pvfdzuimJFykiME9ypjvyWZOP+Qj1NrDjz6JZItXgWN69t2WNU8kyL5BiPbkXry9tp
	 mWaJUp82PpwYEO32dVK8+WgsCmsuB/S6m34x+ook+549DOCoplALylZIRs5UxmXqan
	 fSxQJzWKSOo+Dsv+IIXOqXaexjCB2jG9x6pEveztzlPJy1AS3MJ7pv1+IdVTOGFrqP
	 zX47+xhrZB9fQ==
Received: by mail.growora.pl for <linux-xfs@vger.kernel.org>; Mon, 14 Jul 2025 07:51:22 GMT
Message-ID: <20250714084500-0.1.kl.27hy2.0.tzb3j6zfpr@growora.pl>
Date: Mon, 14 Jul 2025 07:51:22 GMT
From: "Mateusz Hopczak" <mateusz.hopczak@growora.pl>
To: <linux-xfs@vger.kernel.org>
Subject: Wsparcie programistyczne - termin spotkania 
X-Mailer: mail.growora.pl
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Szanowni Pa=C5=84stwo,

czy w Pa=C5=84stwa firmie rozwa=C5=BCaj=C4=85 Pa=C5=84stwo rozw=C3=B3j no=
wego oprogramowania lub potrzebuj=C4=85 zaufanego zespo=C5=82u, kt=C3=B3r=
y przejmie odpowiedzialno=C5=9B=C4=87 za stron=C4=99 technologiczn=C4=85 =
projektu?

Jeste=C5=9Bmy butikowym software housem z 20-osobowym zespo=C5=82em in=C5=
=BCynier=C3=B3w. Specjalizujemy si=C4=99 w projektach high-tech i deeptec=
h =E2=80=93 od zaawansowanych system=C3=B3w AI/ML, przez blockchain i IoT=
, a=C5=BC po aplikacje mobilne, webowe i symulacyjne (m.in. Unreal Engine=
).

Wspieramy firmy technologiczne oraz startupy na r=C3=B3=C5=BCnych etapach=
: od koncepcji, przez development, po skalowanie i optymalizacj=C4=99. Dz=
ia=C5=82amy elastycznie =E2=80=93 jako partnerzy, podwykonawcy lub ventur=
e builderzy.

Je=C5=9Bli szukaj=C4=85 Pa=C5=84stwo zespo=C5=82u, kt=C3=B3ry rozumie z=C5=
=82o=C5=BCono=C5=9B=C4=87 projekt=C3=B3w i wnosi realn=C4=85 warto=C5=9B=C4=
=87 technologiczn=C4=85 =E2=80=93 ch=C4=99tnie porozmawiamy.

Czy mogliby=C5=9Bmy um=C3=B3wi=C4=87 si=C4=99 na kr=C3=B3tk=C4=85 rozmow=C4=
=99, by sprawdzi=C4=87 potencja=C5=82 wsp=C3=B3=C5=82pracy?


Z pozdrowieniami
Mateusz Hopczak
