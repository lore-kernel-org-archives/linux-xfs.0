Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Bug#807879: (no subject)
From: xfs-owner@oss.sgi.com
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4452097268781235176=="
Message-ID: <mailman.4831.1483660992.4130.xfs@oss.sgi.com>
Date: Thu, 05 Jan 2017 18:03:12 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: sandeen@sandeen.net

--===============4452097268781235176==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

This list has been closed.  Please subscribe to the
linux-xfs@vger.kernel.org mailing list and send any future messages
there. You can subscribe to the linux-xfs list at
http://vger.kernel.org/vger-lists.html#linux-xfs

For any questions please post to the new list.


--===============4452097268781235176==
Content-Type: message/rfc822
MIME-Version: 1.0

Return-Path: <debbugs@buxtehude.debian.org>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on oss.sgi.com
X-Spam-Level: 
X-Spam-Status: No, score=-100.0 required=5.0 tests=USER_IN_WHITELIST
	autolearn=ham version=3.3.1
X-Original-To: xfs@oss.sgi.com
Delivered-To: xfs@oss.sgi.com
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C161F7CA0
	for <xfs@oss.sgi.com>; Thu,  5 Jan 2017 18:03:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8570C30406B
	for <xfs@oss.sgi.com>; Thu,  5 Jan 2017 16:03:08 -0800 (PST)
X-ASG-Debug-ID: 1483660985-0bf57c674a24be30001-NocioJ
Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39]) by cuda.sgi.com with ESMTP id a36VI5yDAGrNVWZt (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for <xfs@oss.sgi.com>; Thu, 05 Jan 2017 16:03:06 -0800 (PST)
X-Barracuda-Envelope-From: debbugs@buxtehude.debian.org
X-Barracuda-Effective-Source-IP: buxtehude.debian.org[209.87.16.39]
X-Barracuda-Apparent-Source-IP: 209.87.16.39
Received: from debbugs by buxtehude.debian.org with local (Exim 4.84_2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1cPHzq-0007MJ-UE; Fri, 06 Jan 2017 00:03:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#807879: (no subject)
Reply-To: Eric Sandeen <sandeen@sandeen.net>, 807879@bugs.debian.org
X-ASG-Orig-Subj: Bug#807879: (no subject)
Resent-From: Eric Sandeen <sandeen@sandeen.net>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: XFS Development Team <xfs@oss.sgi.com>
X-Loop: owner@bugs.debian.org
Resent-Date: Fri, 06 Jan 2017 00:03:01 +0000
Resent-Message-ID: <handler.807879.B807879.148366078126772@bugs.debian.org>
X-Debian-PR-Message: followup 807879
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
X-Debian-PR-Source: xfsprogs
Received: via spool by 807879-submit@bugs.debian.org id=B807879.148366078126772
          (code B ref 807879); Fri, 06 Jan 2017 00:03:01 +0000
Received: (at 807879) by bugs.debian.org; 5 Jan 2017 23:59:41 +0000
Received: from sandeen.net ([63.231.237.45])
	by buxtehude.debian.org with esmtp (Exim 4.84_2)
	(envelope-from <sandeen@sandeen.net>)
	id 1cPHwb-0006rJ-1F
	for 807879@bugs.debian.org; Thu, 05 Jan 2017 23:59:41 +0000
Received: from Liberator.example.com (74-95-67-117-Minnesota.hfc.comcastbusiness.net [74.95.67.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 00A5CD4B
	for <807879@bugs.debian.org>; Thu,  5 Jan 2017 17:50:24 -0600 (CST)
To: 807879@bugs.debian.org
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <74b970bc-6b3b-6d73-96bb-bf5822f575bc@sandeen.net>
Date: Thu, 5 Jan 2017 17:50:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:45.0)
 Gecko/20100101 Thunderbird/45.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Greylist: delayed 515 seconds by postgrey-1.35 at buxtehude; Thu, 05 Jan 2017 23:59:40 UTC
X-Barracuda-Connect: buxtehude.debian.org[209.87.16.39]
X-Barracuda-Start-Time: 1483660986
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://192.48.176.15:443/cgi-mod/mark.cgi
X-Barracuda-Scan-Msg-Size: 128
X-Virus-Scanned: by bsmtpd at sgi.com
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=2.7 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.35615
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header

tags: wontfix

Tagging wontfix, as this is not a bug.  Dave points out the proper mkfs options for for older kernels, above.


--===============4452097268781235176==--
