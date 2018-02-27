Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from buxtehude.debian.org ([209.87.16.39]:40464 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751998AbeB0KDM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Feb 2018 05:03:12 -0500
MIME-Version: 1.0
From: "Debian Bug Tracking System" <owner@bugs.debian.org>
Subject: Bug#874209: marked as done (xfsprogs: please bump xfsprogs
 version in experimental and/or unstable from 4.9 to 4.12)
Message-ID: <handler.874209.D874209.151972574526320.ackdone@bugs.debian.org>
References: <CADxRZqz0Cm9G=ezTxB_0JNAG-hHvoBaWQwuJkNwUNtry4H0wyQ@mail.gmail.com>
 <20170904090829.ynxferowufyznptc@yogzotot>
Reply-To: 874209@bugs.debian.org
Date: Tue, 27 Feb 2018 10:03:10 +0000
Content-Type: multipart/mixed; boundary="----------=_1519725790-27105-0"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Anatoly Pugachev <matorola@gmail.com>

This is a multi-part message in MIME format...

------------=_1519725790-27105-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 27 Feb 2018 13:02:22 +0300
with message-id <CADxRZqz0Cm9G=3DezTxB_0JNAG-hHvoBaWQwuJkNwUNtry4H0wyQ@mail=
.gmail.com>
and subject line xfsprogs: please bump xfsprogs version in experimental and=
/or unstable from 4.9 to 4.12
has caused the Debian Bug report #874209,
regarding xfsprogs: please bump xfsprogs version in experimental and/or uns=
table from 4.9 to 4.12
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
874209: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D874209
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1519725790-27105-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 4 Sep 2017 09:16:53 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.1-bugs.debian.org_2005_01_02
	(2015-04-28) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=4.0 tests=DIGITS_LETTERS,
	DKIM_ADSP_CUSTOM_MED,FOURLA,FREEMAIL_FROM,HAS_PACKAGE,NML_ADSP_CUSTOM_MED,
	SPF_SOFTFAIL,X_DEBBUGS_CC autolearn=unavailable autolearn_force=no
	version=3.4.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.5  spammytokens: hammytokens:
Return-path: <matorola@gmail.com>
Received: from u164.east.ru ([195.170.63.164] helo=mx.lavteam.org)
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.89)
	(envelope-from <matorola@gmail.com>)
	id 1donUz-0002wK-1j
	for submit@bugs.debian.org; Mon, 04 Sep 2017 09:16:53 +0000
Received: from yogzotot (yogzotot [192.168.111.254])
	by mx.lavteam.org (Postfix) with ESMTPS id 311BA223E
	for <submit@bugs.debian.org>; Mon,  4 Sep 2017 12:08:29 +0300 (MSK)
Date: Mon, 4 Sep 2017 12:08:29 +0300
From: Anatoly Pugachev <matorola@gmail.com>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfsprogs: please bump xfsprogs version in experimental and/or
 unstable from 4.9 to 4.12
Message-ID: <20170904090829.ynxferowufyznptc@yogzotot>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Debbugs-Cc: matorola@gmail.com
User-Agent: NeoMutt/20170421 (1.8.2)
X-Greylist: delayed 499 seconds by postgrey-1.36 at buxtehude; Mon, 04 Sep 2017 09:16:52 UTC
Delivered-To: submit@bugs.debian.org

Package: xfsprogs
Version: 4.9.0+nmu1
Severity: wishlist

Dear Maintainer,

can you please package a new version of xfsprogs (and all related packages,
including -dev) for xfsprogs? There's already release of linux kernel 4.12.0
in unstable and 4.13-rcX in experimental, while current available xfsprogs-4.9
is too old for this kernels. Current git of xfsprogs has been tagged with
v4.12 as well. Can you please just git-package xfsprogs as 4.12 ? 

Thanks a lot!

-- System Information:
Debian Release: buster/sid
  APT prefers unstable
  APT policy: (990, 'unstable'), (500, 'unreleased'), (500, 'experimental')
Architecture: sparc64

Kernel: Linux 4.13.0-rc7-00247-gd0d6ab53c9ab (SMP w/1 CPU core)
Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8), LANGUAGE=en_US.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash
Init: systemd (via /run/systemd/system)

Versions of packages xfsprogs depends on:
ii  libblkid1     2.29.2-4
ii  libc6         2.24-17
ii  libreadline5  5.2+dfsg-3+b2
ii  libuuid1      2.29.2-4

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
ii  acl      2.2.52-3+b1
ii  attr     1:2.4.47-2
ii  quota    4.03-3
ii  xfsdump  3.1.6+nmu2

-- no debconf information

------------=_1519725790-27105-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 874209-done) by bugs.debian.org; 27 Feb 2018 10:02:25 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.1-bugs.debian.org_2005_01_02
	(2015-04-28) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,HAS_PACKAGE,RCVD_IN_DNSWL_LOW,SPF_PASS,
	TXREP autolearn=ham autolearn_force=no
	version=3.4.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 13; hammy, 44; neutral, 21; spammy, 0.
	spammytokens: hammytokens:0.000-+--Hx-spam-relays-external:229,
	0.000-+--H*r:sk:mail-wm, 0.000-+--H*RU:229,
	0.000-+--Hx-spam-relays-external:sk:mail-wm, 0.000-+--H*RU:sk:mail-wm
Return-path: <matorola@gmail.com>
Received: from mail-wm0-x229.google.com ([2a00:1450:400c:c09::229])
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.89)
	(envelope-from <matorola@gmail.com>)
	id 1eqc5Z-0006qD-8J
	for 874209-done@bugs.debian.org; Tue, 27 Feb 2018 10:02:25 +0000
Received: by mail-wm0-x229.google.com with SMTP id 188so21990250wme.1
        for <874209-done@bugs.debian.org>; Tue, 27 Feb 2018 02:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=7NCp/EsPa0f9kh6YsWNnrNTYPj5a4qMXR6EXHrR9QOI=;
        b=q1prs7Z2wBtkpBLl67dl12yw3HTOZTDp2mjU9k+AdYH5CxYzaws8KJYB+JjGNvf2q3
         Ikv8BKZWy08rRL5DL4cbrXgb8SBywlBiW+ci20n6/M44nbYUgHwv8RNgEF/WBkF4fJvN
         807NGsB3am6A1mAqNEaDFtjyiMoNRQRsTgekch3nNFVVt6KDvhxlqlaWiIHgEcwaMDY0
         J+PXCU+Ih5BKLYYJv2Y763XACrrRqqIXdY5cYaW/5yky+k4BrFEk+9ZZRkQ1d1b7thz5
         B5+n2mVgLDFDngqW7w0TXlrpihYDBV9wUs/7Hj9zKBW0k/6+3wrinli+TdgIYXrJGuJA
         GkVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7NCp/EsPa0f9kh6YsWNnrNTYPj5a4qMXR6EXHrR9QOI=;
        b=tVep/3NgCLcHkhzv4O8IHdDbdvzP/AOyeqDVc4YIpwQGrzzWoDEi1jFyQ5q/whBJQq
         X0nfyMInu8k4ZWvRLbvkPimyWWGeakKgGSCS2YjnUns8LZ8deoxCilOXM5my/d0uea/T
         psTQYRxfmJCyXRIxZZoIKY61HznDBenaicDB1pCGqqJLDE29mRRGHaMR1ZP37td6YqHr
         Pc3cSc1WdJ4cl0AU4ljj1emTPPz8z4DpDiRsfugoIVsQN+J2hP5R9rP7iqYNvpu2Dh69
         umUgbN0BkIKCxAuDT+KO7AfgDC/kfHmSOUlZ6JRfHE59Kz4cKnPxllVWQSesLh49HcM4
         /KIA==
X-Gm-Message-State: APf1xPBmhafF6QmHWRNiOtZdJURAFQqrYq3E2Vm3qu7RvuXYqYucLrl+
	We6YRGUXGaJCW0HVoXQEqW+UZ+YpH+Nq9OBAJuP+r+as
X-Google-Smtp-Source: AH8x224zulyoV0Q5p4OuVMOaHwa5yM326vTnJIlLXP8JMNzzW7/ENs0Bk+BVVG1XaQeg0ohfnd7OY2/5N9IDvyofdQ0=
X-Received: by 10.80.163.7 with SMTP id 7mr18075252edn.258.1519725742569; Tue,
 27 Feb 2018 02:02:22 -0800 (PST)
MIME-Version: 1.0
Received: by 10.80.222.11 with HTTP; Tue, 27 Feb 2018 02:02:22 -0800 (PST)
From: Anatoly Pugachev <matorola@gmail.com>
Date: Tue, 27 Feb 2018 13:02:22 +0300
Message-ID: <CADxRZqz0Cm9G=ezTxB_0JNAG-hHvoBaWQwuJkNwUNtry4H0wyQ@mail.gmail.com>
Subject: xfsprogs: please bump xfsprogs version in experimental and/or
 unstable from 4.9 to 4.12
To: 874209-done@bugs.debian.org
Content-Type: text/plain; charset="UTF-8"

Package: xfsprogs
Version: 4.15

updated to 4.15
------------=_1519725790-27105-0--
