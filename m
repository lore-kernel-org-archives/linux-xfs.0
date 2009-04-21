Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3LFLDiQ134888 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 10:21:14 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8287B22C1BE
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 08:21:10 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id d6JLtogamO2mi60G for <xfs@oss.sgi.com>;
	Tue, 21 Apr 2009 08:21:10 -0700 (PDT)
Message-ID: <49EDE44C.9010804@sandeen.net>
Date: Tue, 21 Apr 2009 10:20:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] put xfs build features into the stats file
References: <49EBDF30.90702@sandeen.net> <20090421141545.GB26214@infradead.org>
In-Reply-To: <20090421141545.GB26214@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Sun, Apr 19, 2009 at 09:34:24PM -0500, Eric Sandeen wrote:
>> Running xfstests on an xfs build w/o xattrs enabled
> 
> How did you disable xattrs?

Oh sorry, meant acls, with CONFIG_XFS_POSIX_ACL

> Should probably be a separate file, though.

Yeah, you're right, I'll go study up on sysfs. :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
