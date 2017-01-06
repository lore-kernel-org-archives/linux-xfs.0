Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Bug#839129: (no subject)
From: xfs-owner@oss.sgi.com
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2259261910334382881=="
Message-ID: <mailman.4832.1483660996.4130.xfs@oss.sgi.com>
Date: Thu, 05 Jan 2017 18:03:16 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: sandeen@sandeen.net

--===============2259261910334382881==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

This list has been closed.  Please subscribe to the
linux-xfs@vger.kernel.org mailing list and send any future messages
there. You can subscribe to the linux-xfs list at
http://vger.kernel.org/vger-lists.html#linux-xfs

For any questions please post to the new list.


--===============2259261910334382881==
Content-Type: message/rfc822
MIME-Version: 1.0

Return-Path: <debbugs@buxtehude.debian.org>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on oss.sgi.com
X-Spam-Level: 
X-Spam-Status: No, score=-100.0 required=5.0 tests=TVD_SPACE_RATIO,
	USER_IN_WHITELIST autolearn=ham version=3.3.1
X-Original-To: xfs@oss.sgi.com
Delivered-To: xfs@oss.sgi.com
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 877027CA0
	for <xfs@oss.sgi.com>; Thu,  5 Jan 2017 18:03:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C42FAC003
	for <xfs@oss.sgi.com>; Thu,  5 Jan 2017 16:03:11 -0800 (PST)
X-ASG-Debug-ID: 1483660987-0bf57c674824be30001-NocioJ
Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39]) by cuda.sgi.com with ESMTP id 9W5kxU2WtYWlWt6v (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for <xfs@oss.sgi.com>; Thu, 05 Jan 2017 16:03:07 -0800 (PST)
X-Barracuda-Envelope-From: debbugs@buxtehude.debian.org
X-Barracuda-Effective-Source-IP: buxtehude.debian.org[209.87.16.39]
X-Barracuda-Apparent-Source-IP: 209.87.16.39
Received: from debbugs by buxtehude.debian.org with local (Exim 4.84_2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1cPHzs-0007MZ-FU; Fri, 06 Jan 2017 00:03:04 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#839129: (no subject)
Reply-To: Eric Sandeen <sandeen@sandeen.net>, 839129@bugs.debian.org
X-ASG-Orig-Subj: Bug#839129: (no subject)
Resent-From: Eric Sandeen <sandeen@sandeen.net>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: XFS Development Team <xfs@oss.sgi.com>
X-Loop: owner@bugs.debian.org
Resent-Date: Fri, 06 Jan 2017 00:03:03 +0000
Resent-Message-ID: <handler.839129.B839129.148366078126770@bugs.debian.org>
X-Debian-PR-Message: followup 839129
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
X-Debian-PR-Source: xfsprogs
Received: via spool by 839129-submit@bugs.debian.org id=B839129.148366078126770
          (code B ref 839129); Fri, 06 Jan 2017 00:03:03 +0000
Received: (at 839129) by bugs.debian.org; 5 Jan 2017 23:59:41 +0000
Received: from sandeen.net ([63.231.237.45])
	by buxtehude.debian.org with esmtp (Exim 4.84_2)
	(envelope-from <sandeen@sandeen.net>)
	id 1cPHwb-0006rK-1H
	for 839129@bugs.debian.org; Thu, 05 Jan 2017 23:59:41 +0000
Received: from Liberator.example.com (74-95-67-117-Minnesota.hfc.comcastbusiness.net [74.95.67.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0CCFC48E4
	for <839129@bugs.debian.org>; Thu,  5 Jan 2017 17:50:58 -0600 (CST)
To: 839129@bugs.debian.org
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d395d26c-8875-c52a-771f-1cc2fae376bd@sandeen.net>
Date: Thu, 5 Jan 2017 17:51:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:45.0)
 Gecko/20100101 Thunderbird/45.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: buxtehude.debian.org[209.87.16.39]
X-Barracuda-Start-Time: 1483660987
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://192.48.176.15:443/cgi-mod/mark.cgi
X-Barracuda-Scan-Msg-Size: 16
X-Virus-Scanned: by bsmtpd at sgi.com
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=2.7 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.35615
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header

tags: moreinfo


--===============2259261910334382881==--
