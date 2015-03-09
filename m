Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B787E7F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 15:14:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45E01AC001
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 13:14:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6v15UxDC5ee4gtLm for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 13:14:00 -0700 (PDT)
Message-ID: <54FDFF07.1010905@sandeen.net>
Date: Mon, 09 Mar 2015 16:13:59 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfault
References: <1145328183.409860.1425916240318.JavaMail.zimbra@rvx.is>	<54FDC6FC.1070303@sandeen.net>	<572429630.410924.1425918276266.JavaMail.zimbra@rvx.is>	<54FDD995.5080307@sandeen.net>	<514254492.412601.1425923432820.JavaMail.zimbra@rvx.is>	<54FDE3EB.6050904@sandeen.net>
	<755575062.413014.1425925464217.JavaMail.zimbra@rvx.is>
In-Reply-To: <755575062.413014.1425925464217.JavaMail.zimbra@rvx.is>
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
To: Rui Gomes <rgomes@rvx.is>
Cc: omar <omar@rvx.is>, xfs <xfs@oss.sgi.com>

On 3/9/15 2:24 PM, Rui Gomes wrote:
> Hello Eric, 
> 
> Thank you very much for looking in to this. Just as a curiosity, I
> can mount the filesystem and access a lot of the files, but some
> files/folders will just hang the kernel, so I need to be careful
> almost file by file tries.
> 
> If I could get the xfs_repair to at least clean the filesystem and
> allow me to browse the remain files without hanging the kernel it
> will be a bonus!
> 
> Once again thank for looking in to this.

Ok, I've sent a patch; you may wish to wait until it's reviewed
before you try it with your filesystem.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
