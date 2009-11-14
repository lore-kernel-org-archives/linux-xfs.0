Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAEGJEU1194000 for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 10:19:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B81C89D0F
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:19:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3vyi7tKnD2jy5ICN for
	<xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:19:35 -0800 (PST)
Date: Sat, 14 Nov 2009 11:19:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: install xfs
Message-ID: <20091114161933.GA17658@infradead.org>
References: <6fccb1d70911132005x43d02e39u9f161ecbce325c61@mail.gmail.com>
	<20091114105417.29066860@galadriel.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091114105417.29066860@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: ming liu <liuming421@gmail.com>, xfs@oss.sgi.com

On Sat, Nov 14, 2009 at 10:54:17AM +0100, Emmanuel Florac wrote:
> Le Sat, 14 Nov 2009 12:05:23 +0800 vous ?criviez:
> 
> > In 32-bit operating system to install xfs do?
> 
> All Linux distributions except RedHat and derivatives (CentOS,
> Fedora) come with XFS included.

Fedora comes with XFS included for a long time.  And even RHEL5 comes
with XFS kernel support, although on x86_64 and only supported if you
sign over your first born to Red Hat.  I'm sure CentOS will have a more
liberal policy for the same codebase given that they support external
XFS modules for a long time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
