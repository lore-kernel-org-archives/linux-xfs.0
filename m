Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D908C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 21:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEE9664FBB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 21:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhBEVLm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Feb 2021 16:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbhBEVJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Feb 2021 16:09:52 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD97C061756
        for <linux-xfs@vger.kernel.org>; Fri,  5 Feb 2021 13:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=Cw9tr4tLTj+QpUKhsH2o9LztgDcGxoi8PjJYggnoo64=; b=u7UdXrz/R65x6zI1UWwnl4qHHm
        bzIQlBQ4GFIRoy6qCbcSIwliLGYDFqTnCi1ol4cAFj7JkLQyAFXRFTdJ1h4L1dt7lLvlrUKK9IUAJ
        gZYox1wGrC6w7+UynjaByK4FO+5CzdFSd1W9WsnNJPv3Z+hrQzF7TSoXvzwsSYZttvmhzirxTbqmH
        aPdji3B7sylxI4UMapzlRSk7wH7cy08+HzjYApmM5mcD8oRz8ck3XhGno+Wo+qs192+ceyJ3ocgGb
        DXEo0jjsomCxPfKiaAffIbaeny8IUleW/vsmT5j1wxt+iQVl46eOTIGEsWib+bgniF8kRtIbISisY
        6XmyP+Zw==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l88Lh-0000EN-LW; Fri, 05 Feb 2021 21:09:05 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Subject: Bug#570704: marked as done (duplicate /usr/share/doc/xfsprogs/changelog{,.Debian}.gz)
Message-ID: <handler.570704.D570704.161255912831407.ackdone@bugs.debian.org>
References: <E1l88IA-0006Cf-Py@fasolo.debian.org>
 <814371d61002201153w2201b4bdteaa3fb0f301607e0@mail.gmail.com>
X-Debian-PR-Message: closed 570704
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: confirmed
X-Debian-PR-Source: xfsprogs
Reply-To: 570704@bugs.debian.org
Date:   Fri, 05 Feb 2021 21:09:05 +0000
Content-Type: multipart/mixed; boundary="----------=_1612559345-866-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1612559345-866-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Fri, 05 Feb 2021 21:05:26 +0000
with message-id <E1l88IA-0006Cf-Py@fasolo.debian.org>
and subject line Bug#570704: fixed in xfsprogs 5.10.0-3
has caused the Debian Bug report #570704,
regarding duplicate /usr/share/doc/xfsprogs/changelog{,.Debian}.gz
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
570704: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D570704
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1612559345-866-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 20 Feb 2010 19:53:47 +0000
X-Spam-Checker-Version: SpamAssassin 3.2.3-bugs.debian.org_2005_01_02
	(2007-08-08) on rietz.debian.org
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 3; hammy, 148; neutral, 44; spammy, 0.
	spammytokens: hammytokens:0.000-+--2.10.2-2, 0.000-+--UD:UTF-8,
	0.000-+--libc6, 0.000-+--x86_64, 0.000-+--Severity
X-Spam-Status: No, score=-9.9 required=4.0 tests=BAYES_00,FOURLA,HAS_PACKAGE,
	SPF_PASS autolearn=ham version=3.2.3-bugs.debian.org_2005_01_02
Return-path: <inkerman42@gmail.com>
Received: from mail-ew0-f210.google.com ([209.85.219.210])
	by rietz.debian.org with esmtp (Exim 4.63)
	(envelope-from <inkerman42@gmail.com>)
	id 1NivOd-0001RE-Eq
	for submit@bugs.debian.org; Sat, 20 Feb 2010 19:53:47 +0000
Received: by ewy2 with SMTP id 2so1267217ewy.5
        for <submit@bugs.debian.org>; Sat, 20 Feb 2010 11:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:mime-version:received:date:message-id:subject
         :from:to:content-type;
        bh=Dv+TFj+PwgP4tdVTviPTvCuduD4pN7+KOkwKe8kg+9s=;
        b=E+lVECDGPKMVZ/A1j1RaSR/Ep7dIc2YAxH4tLkOkXbwbadRg+OrvsSOtVhCFGmOvhV
         k0dFZLapcZ4vmsGzVdp8/qL2CWydG2dn9iTQX4I/f5JJFRgW+u+rtzWr4JhY8F1nShYM
         9hk9c5bmaofvKXY4k3qGEBRHfYYwfMYuygheU=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=J1RYV0kL8UNjN+5V7A+Eqfi914zZP57GHTJSZ/i1g1Ts7CP3lkJnj4TszJlzvTOoqR
         k7cIDIp1zmpfGojrAMewG8cxlzUMEKqurbDEaUaoT+ToCc8ia/ZVo4vABG1AIUT6LyR/
         htPcLJHlrKxRJB4CU6WHipHzo5Corw3YmR+kg=
MIME-Version: 1.0
Received: by 10.213.96.132 with SMTP id h4mr42205ebn.70.1266695618005; Sat, 20 
	Feb 2010 11:53:38 -0800 (PST)
Date: Sat, 20 Feb 2010 20:53:37 +0100
Message-ID: <814371d61002201153w2201b4bdteaa3fb0f301607e0@mail.gmail.com>
Subject: duplicate /usr/share/doc/xfsprogs/changelog{,.Debian}.gz
From: Piotr Engelking <inkerman42@gmail.com>
To: Debian BTS <submit@bugs.debian.org>
Content-Type: text/plain; charset=UTF-8
Delivered-To: submit@bugs.debian.org

Package: xfsprogs
Version: 3.1.1
Severity: minor

There are two identical Debian changelogs in the xfsprogs binary
package:

/usr/share/doc/xfsprogs/changelog.Debian.gz
/usr/share/doc/xfsprogs/changelog.gz

Please remove one of them.


-- System Information:
Debian Release: squeeze/sid
  APT prefers testing
  APT policy: (500, 'testing'), (400, 'unstable'), (300, 'experimental')
Architecture: i386 (x86_64)

Kernel: Linux 2.6.33-rc8 (SMP w/2 CPU cores)
Locale: LANG=C, LC_CTYPE=pl_PL.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/bash

Versions of packages xfsprogs depends on:
ii  libc6                         2.10.2-2   GNU C Library: Shared libraries
ii  libreadline5                  5.2-7      GNU readline and history libraries
ii  libuuid1                      2.16.2-0   Universally Unique ID library

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
ii  acl                           2.2.49-2   Access control list utilities
ii  attr                          1:2.4.44-1 Utilities for manipulating filesys
pn  quota                         <none>     (no description available)
ii  xfsdump                       3.0.4      Administrative utilities for the X

-- no debconf information



------------=_1612559345-866-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 570704-close) by bugs.debian.org; 5 Feb 2021 21:05:28 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,MD5_SHA1_SUM,PGPSIGNATURE,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,TXREP autolearn=ham
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 9; hammy, 150; neutral, 207; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--Hx-spam-relays-external:sk:envelop, 0.000-+--H*r:138.16.160
Return-path: <envelope@ftp-master.debian.org>
Received: from muffat.debian.org ([2607:f8f0:614:1::1274:33]:40994)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=muffat.debian.org,EMAIL=hostmaster@muffat.debian.org (verified)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l88IC-0008AC-FD
	for 570704-close@bugs.debian.org; Fri, 05 Feb 2021 21:05:28 +0000
Received: from fasolo.debian.org ([138.16.160.17]:51906)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l88IB-000549-KX; Fri, 05 Feb 2021 21:05:27 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l88IA-0006Cf-Py; Fri, 05 Feb 2021 21:05:26 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Reply-To: Bastian Germann <bastiangermann@fishpost.de>
To: 570704-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#570704: fixed in xfsprogs 5.10.0-3
Message-Id: <E1l88IA-0006Cf-Py@fasolo.debian.org>
Date: Fri, 05 Feb 2021 21:05:26 +0000
X-CrossAssassin-Score: 2

Source: xfsprogs
Source-Version: 5.10.0-3
Done: Bastian Germann <bastiangermann@fishpost.de>

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive.

A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 570704@bugs.debian.org,
and the maintainer will reopen the bug report if appropriate.

Debian distribution maintenance software
pp.
Bastian Germann <bastiangermann@fishpost.de> (supplier of updated xfsprogs package)

(This message was generated automatically at their request; if you
believe that there is a problem with it please contact the archive
administrators by mailing ftpmaster@ftp-master.debian.org)


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 05 Feb 2021 00:18:31 +0100
Source: xfsprogs
Architecture: source
Version: 5.10.0-3
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bastiangermann@fishpost.de>
Closes: 570704 981361
Changes:
 xfsprogs (5.10.0-3) unstable; urgency=medium
 .
   * Drop unused dh-python from Build-Depends (Closes: #981361)
   * Only build for Linux
   * Prevent installing duplicate changelog (Closes: #570704)
Checksums-Sha1:
 900af5be1841442f9be8a64e9f29d9b961bb53da 2047 xfsprogs_5.10.0-3.dsc
 318931355b60145dbb335852c8848830ed13429e 13884 xfsprogs_5.10.0-3.debian.tar.xz
 df3f27fb3acb4a0c092d9620948a90fde44bc198 6145 xfsprogs_5.10.0-3_source.buildinfo
Checksums-Sha256:
 5515e789676e657d92fde061a40875313bbc906f30343e35a164d2df699db4da 2047 xfsprogs_5.10.0-3.dsc
 8ff1807e228afe92f489d19ddbc415358b03375320ceead38debd4408511862a 13884 xfsprogs_5.10.0-3.debian.tar.xz
 d796004671c464b0dc82ff31c3e0dd4464d44e6e7a235cde59eaa47b740fc421 6145 xfsprogs_5.10.0-3_source.buildinfo
Files:
 3eb63eadc5601aa0f5d6a6b32479a45c 2047 admin optional xfsprogs_5.10.0-3.dsc
 be5f3ab288c96161d358308e7c810a89 13884 admin optional xfsprogs_5.10.0-3.debian.tar.xz
 e5eca5118bf2497e0cfc13812c07558f 6145 admin optional xfsprogs_5.10.0-3_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHPBAEBCgA5FiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmAdr2MbHGJhc3RpYW5n
ZXJtYW5uQGZpc2hwb3N0LmRlAAoJEB9ceotFVkMU0vYL/iRxjvSoq8/YdiozpiYP
D7ZVU4R75eq5l97NkAw8KqA81yYjYLsLNFLG4FPdFAagl4M2FbdoLYmPsl7XmaB+
Bz40dlxYoNV9u/JyqpnJEL9MpDalfc0FGHpdz3xCbjg0d/28DOuHXOzjy48o7Ac5
G+eQMEu/XcHLD+c0O00odPngq1blNiRWt6nINpXH7CU5q49Cv/UiqDOI6CjMnqnm
2AhqQbCP3//jCIIyYpGqawyh0RcslmigYWc0vGTtanuhe6JOi+CFKP5JpCIQ7fi3
5aJgTJRhsBSKO6YV33bTGRxW6rZgiLUehKQOqyYS0f2IaaGYGxMquoLjCoOvrD4H
Ove4eq/6z+Ad33+KBtIQV/zwsOjXAjgejPzQiTJOWfv7Rq9/o1Bl8dlKSz8KZYWu
dovtOxiVyh/jj2XTaR42l8XiR6mF1vdnWB5+A8Uom1FkykOfNE4JMmRVp9++DyH5
F8DcQabeYYPttu+C+i+llhqhJVOQGm7E6rltXpy4IX1Eaw==
=n4pB
-----END PGP SIGNATURE-----
------------=_1612559345-866-0--
