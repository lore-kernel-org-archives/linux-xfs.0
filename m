Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF76C33CB1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 09:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DFB72082F
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 09:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgAQJEt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 04:04:49 -0500
Received: from buxtehude.debian.org ([209.87.16.39]:60192 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgAQJEt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 04:04:49 -0500
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1isN6w-0002zk-2T; Fri, 17 Jan 2020 08:36:10 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     =?UTF-8?Q?G=C3=BCrkan?= Myczko <gurkan@phys.ethz.ch>
Subject: Bug#510516: marked as done (is not a native package)
Message-ID: <handler.510516.D144876.157925012211064.ackdone@bugs.debian.org>
References: <d99ff6bb9a3f9f1774358e10a61f8717@phys.ethz.ch>
 <20090102182138.17804.88243.reportbug@intrepid.palfrader.org>
X-Debian-PR-Message: closed 510516
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Source: xfsprogs
Reply-To: 510516@bugs.debian.org
Date:   Fri, 17 Jan 2020 08:36:10 +0000
Content-Type: multipart/mixed; boundary="----------=_1579250170-11489-2"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1579250170-11489-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Fri, 17 Jan 2020 09:35:20 +0100
with message-id <d99ff6bb9a3f9f1774358e10a61f8717@phys.ethz.ch>
and subject line non-native package
has caused the Debian Bug report #144876,
regarding is not a native package
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
144876: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D144876
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1579250170-11489-2
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 2 Jan 2009 18:21:41 +0000
X-Spam-Checker-Version: SpamAssassin 3.2.3-bugs.debian.org_2005_01_02
	(2007-08-08) on rietz.debian.org
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 21; hammy, 70; neutral, 30; spammy, 0.
	spammytokens: hammytokens:0.000-+--H*M:reportbug, 0.000-+--H*MI:reportbug,
	0.000-+--H*x:reportbug, 0.000-+--Severity, 0.000-+--H*UA:reportbug
X-Spam-Status: No, score=-14.4 required=4.0 tests=AWL,BAYES_00,FROMDEVELOPER,
	HAS_PACKAGE,XMAILER_REPORTBUG autolearn=ham
	version=3.2.3-bugs.debian.org_2005_01_02
Return-path: <weasel@debian.org>
Received: from anguilla.debian.or.at ([86.59.21.37])
	by rietz.debian.org with esmtp (Exim 4.63)
	(envelope-from <weasel@debian.org>)
	id 1LIoeT-0005jg-Fj
	for submit@bugs.debian.org; Fri, 02 Jan 2009 18:21:41 +0000
Received: from intrepid.palfrader.org (argos.campus-sbg.at [62.99.152.178])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "intrepid.palfrader.org", Issuer "Peter Palfrader" (verified OK))
	by anguilla.debian.or.at (Postfix) with ESMTP id 9FDBD10F9C1;
	Fri,  2 Jan 2009 19:21:39 +0100 (CET)
Received: by intrepid.palfrader.org (Postfix, from userid 1000)
	id 155CD1620B8; Fri,  2 Jan 2009 19:21:39 +0100 (CET)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Peter Palfrader <weasel@debian.org>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: is not a native package
Message-ID: <20090102182138.17804.88243.reportbug@intrepid.palfrader.org>
X-Mailer: reportbug 3.47
Date: Fri, 02 Jan 2009 19:21:38 +0100
Delivered-To: submit@bugs.debian.org

Package: xfsprogs
Version: 2.10.2-1
Severity: normal

Hi,

2.10.2-1 indicates that this is a non-native package, but it's not
uploaded like that:

-rw-r--r--  1 root root    924 Dec 20 00:47 xfsprogs_2.10.2-1.dsc
-rw-r--r--  1 root root 971568 Dec 20 00:47 xfsprogs_2.10.2-1.tar.gz

Cheers,
Peter



------------=_1579250170-11489-2
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 144876-done) by bugs.debian.org; 17 Jan 2020 08:35:22 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=4.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,TXREP
	autolearn=no autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 13; hammy, 66; neutral, 21; spammy, 0.
	spammytokens: hammytokens:0.000-+--H*F:U*gurkan,
	0.000-+--H*RU:sk:phd-mai, 0.000-+--H*RU:192.168.127.53,
	0.000-+--H*r:sk:phd-mxi, 0.000-+--H*RU:sk:phd-mxi
Return-path: <gurkan@phys.ethz.ch>
Received: from phd-imap.ethz.ch ([129.132.80.51]:42090)
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <gurkan@phys.ethz.ch>)
	id 1isN69-0002s4-UM
	for 144876-done@bugs.debian.org; Fri, 17 Jan 2020 08:35:22 +0000
Received: from localhost (phd-mailscan.phys-int.ethz.ch [192.168.127.49])
	by phd-imap.ethz.ch (Postfix) with ESMTP id 47zZBc2Wctz3C
	for <144876-done@bugs.debian.org>; Fri, 17 Jan 2020 09:35:20 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at phys.ethz.ch
Received: from phd-mxin.ethz.ch ([192.168.127.53])
	by localhost (phd-mailscan.ethz.ch [192.168.127.49]) (amavisd-new, port 10024)
	with LMTP id 7n1uPYDlBc6s for <144876-done@bugs.debian.org>;
	Fri, 17 Jan 2020 09:35:20 +0100 (CET)
Received: from webmail.phys.ethz.ch (phd-imap.phys-int.ethz.ch [192.168.127.51])
	by phd-mxin.ethz.ch (Postfix) with ESMTP id 47zZBc0yc5z2B
	for <144876-done@bugs.debian.org>; Fri, 17 Jan 2020 09:35:20 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Jan 2020 09:35:20 +0100
From: =?UTF-8?Q?G=C3=BCrkan_Myczko?= <gurkan@phys.ethz.ch>
To: 144876-done@bugs.debian.org
Subject: non-native package
User-Agent: Roundcube Webmail/1.4.2
Message-ID: <d99ff6bb9a3f9f1774358e10a61f8717@phys.ethz.ch>
X-Sender: gurkan@phys.ethz.ch

for many months, it's been a non-native debian package again
------------=_1579250170-11489-2--
