Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C88C33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 09:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 349D9214AF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 09:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgAQJEv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 04:04:51 -0500
Received: from buxtehude.debian.org ([209.87.16.39]:60194 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgAQJEv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 04:04:51 -0500
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1isN6x-000304-UZ; Fri, 17 Jan 2020 08:36:11 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     =?UTF-8?Q?G=C3=BCrkan?= Myczko <gurkan@phys.ethz.ch>
Subject: Bug#921509: marked as done (please package new upstream version)
Message-ID: <handler.921509.D921509.15792499809401.ackdone@bugs.debian.org>
References: <4106b3f24b32e6b7b0dc40a9f7fce9cb@phys.ethz.ch>
 <154945158913.355.8921747976683050137.reportbug@merkaba.lichtvoll>
X-Debian-PR-Message: closed 921509
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Source: xfsprogs
Reply-To: 921509@bugs.debian.org
Date:   Fri, 17 Jan 2020 08:36:11 +0000
Content-Type: multipart/mixed; boundary="----------=_1579250171-11529-0"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1579250171-11529-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Fri, 17 Jan 2020 09:32:41 +0100
with message-id <4106b3f24b32e6b7b0dc40a9f7fce9cb@phys.ethz.ch>
and subject line please package new upstream version
has caused the Debian Bug report #921509,
regarding please package new upstream version
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
921509: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D921509
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1579250171-11529-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 6 Feb 2019 11:13:14 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=4.0 tests=BAYES_00,FOURLA,HAS_PACKAGE,
	RCVD_IN_PBL,RDNS_DYNAMIC,SPF_NEUTRAL,TXREP,XMAILER_REPORTBUG,
	X_DEBBUGS_CC autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 16; hammy, 150; neutral, 66; spammy,
	0. spammytokens: hammytokens:0.000-+--python3, 0.000-+--H*M:reportbug,
	0.000-+--H*MI:reportbug, 0.000-+--H*x:reportbug, 0.000-+--H*ct:us-ascii
Return-path: <martin.steigerwald@proact.de>
Received: from ppp-46-244-244-56.dynamic.mnet-online.de ([46.244.244.56] helo=merkaba.lichtvoll)
	by buxtehude.debian.org with esmtp (Exim 4.89)
	(envelope-from <martin.steigerwald@proact.de>)
	id 1grL8i-0002El-9M
	for submit@bugs.debian.org; Wed, 06 Feb 2019 11:13:14 +0000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Martin Steigerwald <martin.steigerwald@proact.de>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: please package new upstream version
Message-ID: <154945158913.355.8921747976683050137.reportbug@merkaba.lichtvoll>
X-Mailer: reportbug 7.5.2
Date: Wed, 06 Feb 2019 12:13:09 +0100
X-Debbugs-Cc: martin.steigerwald@proact.de, martin.steigerwald@proact.de
Delivered-To: submit@bugs.debian.org

Package: xfsprogs
Version: 4.15.1-1
Severity: normal

Dear Nathan, dear Anibal, dear maintainers.

Please package a new upstream version, preferably before the
Debian Buster freeze. The currently in Debian packages one is
from February 2018.

Most recent release is 4.19.0:
https://mirrors.edge.kernel.org/pub/linux/utils/fs/xfs/

Thank you,
Martin

-- System Information:
Debian Release: buster/sid
  APT prefers unstable-debug
  APT policy: (500, 'unstable-debug'), (500, 'unstable'), (200, 'experimental')
Architecture: amd64 (x86_64)
Foreign Architectures: i386

Kernel: Linux 5.0.0-rc4-tp520 (SMP w/4 CPU cores; PREEMPT)
Kernel taint flags: TAINT_OOT_MODULE
Locale: LANG=de_DE.UTF-8, LC_CTYPE=de_DE.UTF-8 (charmap=UTF-8), LANGUAGE= (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash
Init: systemd (via /run/systemd/system)

Versions of packages xfsprogs depends on:
ii  libblkid1           2.33.1-0.1
ii  libc6               2.28-5
ii  libdevmapper1.02.1  2:1.02.155-2
ii  libreadline5        5.2+dfsg-3+b2
ii  libunistring2       0.9.10-1
ii  libuuid1            2.33.1-0.1
ii  python3             3.7.2-1

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
ii  acl      2.2.52-3+b1
ii  attr     1:2.4.47-2+b2
pn  quota    <none>
ii  xfsdump  3.1.6+nmu2+b2

-- no debconf information

------------=_1579250171-11529-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 921509-done) by bugs.debian.org; 17 Jan 2020 08:33:00 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=4.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,TXREP
	autolearn=no autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 14; hammy, 74; neutral, 26; spammy, 0.
	spammytokens: hammytokens:0.000-+--H*F:U*gurkan,
	0.000-+--H*RU:sk:phd-mai, 0.000-+--H*RU:192.168.127.53,
	0.000-+--H*RU:sk:phd-mxi, 0.000-+--H*r:sk:phd-mxi
Return-path: <gurkan@phys.ethz.ch>
Received: from phd-imap.ethz.ch ([129.132.80.51]:39442)
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <gurkan@phys.ethz.ch>)
	id 1isN3r-0002RI-Qs
	for 921509-done@bugs.debian.org; Fri, 17 Jan 2020 08:33:00 +0000
Received: from localhost (phd-mailscan.phys-int.ethz.ch [192.168.127.49])
	by phd-imap.ethz.ch (Postfix) with ESMTP id 47zZ7Y57r9z3C
	for <921509-done@bugs.debian.org>; Fri, 17 Jan 2020 09:32:41 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at phys.ethz.ch
Received: from phd-mxin.ethz.ch ([192.168.127.53])
	by localhost (phd-mailscan.ethz.ch [192.168.127.49]) (amavisd-new, port 10024)
	with LMTP id B_FvDmRmwpmr for <921509-done@bugs.debian.org>;
	Fri, 17 Jan 2020 09:32:41 +0100 (CET)
Received: from webmail.phys.ethz.ch (phd-imap.phys-int.ethz.ch [192.168.127.51])
	by phd-mxin.ethz.ch (Postfix) with ESMTP id 47zZ7Y3pTNz2S
	for <921509-done@bugs.debian.org>; Fri, 17 Jan 2020 09:32:41 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Jan 2020 09:32:41 +0100
From: =?UTF-8?Q?G=C3=BCrkan_Myczko?= <gurkan@phys.ethz.ch>
To: 921509-done@bugs.debian.org
Subject: please package new upstream version
User-Agent: Roundcube Webmail/1.4.2
Message-ID: <4106b3f24b32e6b7b0dc40a9f7fce9cb@phys.ethz.ch>
X-Sender: gurkan@phys.ethz.ch

Dear Martin

This bug has been closed more than a year ago, but not via 
debian/changelog, so closing it now.

Best,
------------=_1579250171-11529-0--
