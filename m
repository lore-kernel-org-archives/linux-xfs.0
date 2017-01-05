Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Bug#839129: (no subject)
From: xfs-owner@oss.sgi.com
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6347949392380920004=="
Message-ID: <mailman.4830.1483660632.4130.xfs@oss.sgi.com>
Date: Thu, 05 Jan 2017 17:57:12 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: sandeen@sandeen.net

--===============6347949392380920004==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

This list has been closed.  Please subscribe to the
linux-xfs@vger.kernel.org mailing list and send any future messages
there. You can subscribe to the linux-xfs list at
http://vger.kernel.org/vger-lists.html#linux-xfs

For any questions please post to the new list.


--===============6347949392380920004==
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
	by oss.sgi.com (Postfix) with ESMTP id 580867CA0
	for <xfs@oss.sgi.com>; Thu,  5 Jan 2017 17:57:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17D5B304062
	for <xfs@oss.sgi.com>; Thu,  5 Jan 2017 15:57:10 -0800 (PST)
X-ASG-Debug-ID: 1483660627-0bf8151b794ab7a0001-NocioJ
Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39]) by cuda.sgi.com with ESMTP id lc29C6jfPYAcImee (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for <xfs@oss.sgi.com>; Thu, 05 Jan 2017 15:57:07 -0800 (PST)
X-Barracuda-Envelope-From: debbugs@buxtehude.debian.org
X-Barracuda-Effective-Source-IP: buxtehude.debian.org[209.87.16.39]
X-Barracuda-Apparent-Source-IP: 209.87.16.39
Received: from debbugs by buxtehude.debian.org with local (Exim 4.84_2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1cPHu2-0006gF-RG; Thu, 05 Jan 2017 23:57:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#839129: (no subject)
Reply-To: Eric Sandeen <sandeen@sandeen.net>, 839129@bugs.debian.org
X-ASG-Orig-Subj: Bug#839129: (no subject)
Resent-From: Eric Sandeen <sandeen@sandeen.net>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: XFS Development Team <xfs@oss.sgi.com>
X-Loop: owner@bugs.debian.org
Resent-Date: Thu, 05 Jan 2017 23:57:01 +0000
Resent-Message-ID: <handler.839129.B839129.148366048124912@bugs.debian.org>
X-Debian-PR-Message: followup 839129
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
X-Debian-PR-Source: xfsprogs
Received: via spool by 839129-submit@bugs.debian.org id=B839129.148366048124912
          (code B ref 839129); Thu, 05 Jan 2017 23:57:01 +0000
Received: (at 839129) by bugs.debian.org; 5 Jan 2017 23:54:41 +0000
Received: from sandeen.net ([63.231.237.45])
	by buxtehude.debian.org with esmtp (Exim 4.84_2)
	(envelope-from <sandeen@sandeen.net>)
	id 1cPHrl-0006NA-Dm
	for 839129@bugs.debian.org; Thu, 05 Jan 2017 23:54:41 +0000
Received: from Liberator.example.com (74-95-67-117-Minnesota.hfc.comcastbusiness.net [74.95.67.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 86B1948E3
	for <839129@bugs.debian.org>; Thu,  5 Jan 2017 17:46:37 -0600 (CST)
To: 839129@bugs.debian.org
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9beb4d47-8704-b0d0-ea57-268684dd1cec@sandeen.net>
Date: Thu, 5 Jan 2017 17:47:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:45.0)
 Gecko/20100101 Thunderbird/45.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Greylist: delayed 443 seconds by postgrey-1.35 at buxtehude; Thu, 05 Jan 2017 23:54:41 UTC
X-Barracuda-Connect: buxtehude.debian.org[209.87.16.39]
X-Barracuda-Start-Time: 1483660627
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://192.48.157.11:443/cgi-mod/mark.cgi
X-Barracuda-Scan-Msg-Size: 150
X-Virus-Scanned: by bsmtpd at sgi.com
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=2.7 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.35615
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header

If you can turn on tracing for the xfs_swap_extent\* tracepoints and rerun, that might give us more information about the failure.

Thanks,
-Eric


--===============6347949392380920004==--
