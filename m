Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96Ihund084604 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 13:43:56 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF09EBD61D0
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 11:45:20 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id HMWuEh8qM8VzZahs for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 11:45:20 -0700 (PDT)
Date: Wed, 7 Oct 2009 05:45:11 +1100 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <1964191006.21461254854711239.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <4ACB6686.9080205@sandeen.net>
Subject: Re: moving libhandle to /usr
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, vapier@gentoo.org, xfs@oss.sgi.com


----- "Eric Sandeen" <sandeen@sandeen.net> wrote:

> Christoph Hellwig wrote:
> > Currently we install the versioned libhandle into /lib by default,
> > and all other libraries into /usr.  Given that no program in /
> actually
> > uses libhandle this seems rather awkward to me.  From Mike's
> comments
> > in the past I think Gentoo already installs it into /usr anyway.
> > 
> > Is there anything speaking against moving all libraries to /usr and
> > switching Debian/Fedora to that aswell? 
> > 
> 
> Seems fine to me;

*nod* - looks ok to me too.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
