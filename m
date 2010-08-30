Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7UCDnZG003127 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 07:13:49 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EAEE341CB
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 05:14:26 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id EvHjI6BiUXG0oQlD
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 05:14:26 -0700 (PDT)
Message-ID: <4C7BA0A0.5090202@profihost.ag>
Date: Mon, 30 Aug 2010 14:14:24 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: XFS Quota Check OOM
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

on one of our systems i want to activate prjquota support. The relevant 
disk is the root disk so i added prjquota to rootflags kernel line.

But when i do so i always get OOM out of Memory while checking quota's. 
I also upgraded the system from 8GB to 16GB RAM but still the same. 
Kernel is vanilla 2.6.32.19.

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
