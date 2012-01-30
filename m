Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0U9C2BR001359
	for <linux-xfs@oss.sgi.com>; Mon, 30 Jan 2012 03:12:03 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Dmj7ddlRuqJpJb5H
	for <linux-xfs@oss.sgi.com>; Mon, 30 Jan 2012 01:12:01 -0800 (PST)
Message-ID: <4F265EE3.6020908@hardwarefreak.com>
Date: Mon, 30 Jan 2012 03:12:03 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Placing the root partition on an XFS filesystem is not supported
References: <loom.20120129T133929-288@post.gmane.org>
In-Reply-To: <loom.20120129T133929-288@post.gmane.org>
Reply-To: stan@hardwarefreak.com
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
To: Marcos Mello <marcosfrm@gmail.com>
Cc: linux-xfs@oss.sgi.com

On 1/29/2012 6:46 AM, Marcos Mello wrote:
> http://git.fedorahosted.org/git/?p=anaconda.git;a=commit;h=b3e19d43840f6c4015fab75411853003fcf26a63
> 
> Does someone knows why? I'm trying to get rid of EXT* partitions on my new
> CentOS 6.2 installs but apparently it will not be possible.

I'm unsure what this Fedora commit is all about, but in the general
Linux case you can put root on XFS, with a minor caveat.  See:

http://www.xfs.org/index.php/XFS_FAQ#Q:_Can_XFS_be_used_for_a_root_filesystem.3F

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
