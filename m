Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BFD357F47
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 02:45:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5DFB3AC002
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 00:45:30 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id dyopBXzunEnghtp1 for
	<xfs@oss.sgi.com>; Tue, 21 Oct 2014 00:45:26 -0700 (PDT)
Received: from merkaba.localnet (blackhole.teamix.net [194.150.191.251])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 713D443E
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 09:45:25 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: High I/O waits
Date: Tue, 21 Oct 2014 09:45:24 +0200
Message-ID: <1594296.7DZVsZW4j9@merkaba>
In-Reply-To: <5446001A.5000909@ocius.nl>
References: <5446001A.5000909@ocius.nl>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Am Dienstag, 21. Oktober 2014, 08:41:30 schrieb Stefan Bottelier | Ocius.nl:
> Hello,

Hi Stefan,

> We have change ore servers from Linux kernel 3.2.63 to 3.12.30, and now
> we have very more I/O waits on the block device.
> Are the some big changes in this version ? And we mount now with /sdb
> /srv but are the some mount options for better performance ?
> 
> I hope somebody can help me with this.

Not yet, as your report lacks any details necessary to even make a guess what 
the cause of your problem might be.

Please read

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

and add the necessary information.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
