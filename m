Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0TMefRw238860 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 16:40:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 867D6CCC68
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 14:40:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xVIJkNZ80NFXeyDw for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2009 14:40:00 -0800 (PST)
Date: Thu, 29 Jan 2009 17:39:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs open questions
Message-ID: <20090129223929.GA20346@infradead.org>
References: <200901270928.29215@zmi.at> <497F130F.4010107@sandeen.net>
	<200901280937.23743@zmi.at> <498025D2.1060706@sgi.com>
	<4980754D.5060203@sandeen.net> <49813E27.9010309@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49813E27.9010309@sgi.com>
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
To: Mark Goodwin <markgw@sgi.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Jan 29, 2009 at 04:27:03PM +1100, Mark Goodwin wrote:
> doc & ppt binary formats. My first thought was another git repository at
> git://oss/xfs/cmds/xfsdocs.git which would also include the web site html
> content. But doc and ppt binary files apparently always result in git merge
> conflicts (can't be patched) ... thoughts?  Perhaps convert the content
> to wiki or maybe html and manage changes that way?

Better a git with merge conflicts than no SCM at all.  So let's get it
out and into the new xfsdocs.git repo ASAP, and we'll see if we can
convert it to a more open format later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
