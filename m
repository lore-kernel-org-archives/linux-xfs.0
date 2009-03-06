Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n26HmHsc225208 for <xfs@oss.sgi.com>; Fri, 6 Mar 2009 11:48:18 -0600
Received: from mail-bw0-f168.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4ECFC179E33
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2009 09:47:50 -0800 (PST)
Received: from mail-bw0-f168.google.com (mail-bw0-f168.google.com
	[209.85.218.168]) by cuda.sgi.com with ESMTP id
	Ovf2GfhKsJGWeAjh for <xfs@oss.sgi.com>;
	Fri, 06 Mar 2009 09:47:50 -0800 (PST)
Received: by bwz12 with SMTP id 12so458758bwz.20
	for <xfs@oss.sgi.com>; Fri, 06 Mar 2009 09:47:50 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Mar 2009 19:47:49 +0200
Message-ID: <5d96567b0903060947x5678a4b4tdfbc76a786dfe257@mail.gmail.com>
Subject: xfs_irecover
From: Raz <raziebe@gmail.com>
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
To: hch@infradead.org
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hello
i am trying to use xfs_ircover. when i typed:
xfs_irecover -N 100  -D /dev/md5 -o /d2/temp/
it just hangs. how about some verbosity ?
i am using 2.6.18-8.el5 kernel
thank you
raz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
