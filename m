Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o921YG9H138220 for <xfs@oss.sgi.com>; Fri, 1 Oct 2010 20:34:16 -0500
Received: from master.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 665BB1BFE515
	for <xfs@oss.sgi.com>; Fri,  1 Oct 2010 18:35:17 -0700 (PDT)
Received: from master.debian.org (master.debian.org [70.103.162.29]) by
	cuda.sgi.com with ESMTP id 7B9epFhGsvIZEXmF for
	<xfs@oss.sgi.com>; Fri, 01 Oct 2010 18:35:17 -0700 (PDT)
Date: Sat, 2 Oct 2010 11:34:59 +1000
From: =?iso-8859-1?Q?An=EDbal?= Monsalve Salazar <anibal@debian.org>
Subject: Re: xfsprogs Debian mantainaince
Message-ID: <20101002013458.GA3547@master.debian.org>
References: <97008679.1517661285974121218.JavaMail.root@mail-au.aconex.com>
	<1371146962.1517681285974171988.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371146962.1517681285974171988.JavaMail.root@mail-au.aconex.com>
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
To: nathans@debian.org
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Oct 02, 2010 at 09:02:51AM +1000, nathans@debian.org wrote:
>----- "Christoph Hellwig" <hch@infradead.org> wrote:
>>On Sat, Aug 14, 2010 at 07:15:13AM -0400, Christoph Hellwig wrote:
>>>Also can we add xfs@oss.sgi.com to the Cc list for debian xfs
>>>bugreports? I think most issues are upstream ones anyway, and
>>>automatically sending them to the XFS list will get them a bigger
>>>audience.
>>
>>Guys, any idea how to get this done?
>
>Not sure ... I'm guessing we need to make an "official" xfs
>debian maintenance team.  Probably some process exists for
>that, somewhere, which I haven't been able to find so far -
>Anibal do you know?

Just change the maintainer to xfs@oss in debian/control and add yourself
as an uploader.

The only problem is that xfs@oss may not accept mail from any mail
address submitting a new bug report or/replying to an existing bug
report.

>(http://wiki.debian.org/Teams looks like a place to start?) and then
>add xfs@oss as a contact address on that list.

The Teams wiki page is optional.

>cheers.
>
>--
>Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
