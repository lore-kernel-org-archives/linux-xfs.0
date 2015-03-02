Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E0A037F60
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 17:48:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F064AC001
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 15:48:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4auvovG0UUSfPd3P for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 15:48:23 -0800 (PST)
Received: from Liberator.local (unknown [67.138.38.246])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 257C065ECD39
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 17:48:23 -0600 (CST)
Message-ID: <54F4F6C7.9020706@sandeen.net>
Date: Mon, 02 Mar 2015 17:48:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfsprogs: xfs_db crc fixes/changes
References: <540B4399.4020804@sandeen.net>
In-Reply-To: <540B4399.4020804@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

Ping on these.  They still apply & build cleanly.

Thanks,
-Eric

On 9/6/14 12:25 PM, Eric Sandeen wrote:
> 2 patches related to crcs in xfs_db,
> 
> 1) display inode CRC status when read, and revalidate it when written
> 2) add a new "crc" command to validate, invalidate, or revalidate the
>    CRC on a disk structure
> 
> thanks,
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
