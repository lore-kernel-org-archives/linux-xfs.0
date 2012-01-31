Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VHDeTJ058888 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 11:13:40 -0600
Received: from mail-yw0-f46.google.com (mail-yw0-f46.google.com
	[209.85.213.46]) by cuda.sgi.com with ESMTP id 0BOToP18Opsw4vcc
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 Jan 2012 09:13:38 -0800 (PST)
Received: by yhoo21 with SMTP id o21so149463yho.5
	for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 09:13:37 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 31 Jan 2012 09:13:36 -0800
Message-ID: <CAM=3LEd2yu6rgSCg=6-Mop7wgKK5FnVKx6E=H2NapzJQ9ahSeg@mail.gmail.com>
Subject: Identify patches for superblock changes for Crossmeta
From: sam supramani <suprasam@crossmeta.org>
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
To: xfs@oss.sgi.com

Hi,

I am trying to get Crossmeta that includes windows port of XFS file
system, to recognize newer ondisk format changes seen with the newer
linux kernels.(RHEL6)
The crossmeta-xfs port in https://github.com/crossmeta/sgi is quite
old based on XFS 1.1 release with log v2 patches added later.

I am interested in knowing submittal ID for the following changes;
attr=2 lazy-count=1.  Getting crossmeta to work with latest sources
would be a bigger task, compared to selectively pulling the patch
diffs.

If file system was made with attr=0 it works fine.

The program  is free to use and is available at http://www.crossmeta.org/redmine


Thanks,
Sam.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
