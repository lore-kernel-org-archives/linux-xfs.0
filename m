Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0TCo6Dn050451
	for <linux-xfs@oss.sgi.com>; Sun, 29 Jan 2012 06:50:08 -0600
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id alE9hl9VrfvVxgDs (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Sun, 29 Jan 2012 04:50:05 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RrUCo-0002AC-VE
	for linux-xfs@oss.sgi.com; Sun, 29 Jan 2012 13:50:03 +0100
Received: from bd206cc2.virtua.com.br ([bd206cc2.virtua.com.br])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sun, 29 Jan 2012 13:50:02 +0100
Received: from marcosfrm by bd206cc2.virtua.com.br with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sun, 29 Jan 2012 13:50:02 +0100
From: Marcos Mello <marcosfrm@gmail.com>
Subject: Placing the root partition on an XFS filesystem is not supported
Date: Sun, 29 Jan 2012 12:46:42 +0000 (UTC)
Message-ID: <loom.20120129T133929-288@post.gmane.org>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

http://git.fedorahosted.org/git/?p=anaconda.git;a=commit;h=b3e19d43840f6c4015fab75411853003fcf26a63

Does someone knows why? I'm trying to get rid of EXT* partitions on my new
CentOS 6.2 installs but apparently it will not be possible.

Marcos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
