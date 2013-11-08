Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E85427FA2
	for <xfs@oss.sgi.com>; Fri,  8 Nov 2013 15:28:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D41678F8049
	for <xfs@oss.sgi.com>; Fri,  8 Nov 2013 13:28:34 -0800 (PST)
Received: from boogeyman.armory.com
	(adsl-76-230-21-225.dsl.pltn13.sbcglobal.net [76.230.21.225])
	by cuda.sgi.com with ESMTP id GJ8JflwWOcj1azbN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Nov 2013 13:28:33 -0800 (PST)
Date: Fri, 8 Nov 2013 13:29:09 -0800
From: Phil White <cerise-xfs@l.armory.com>
Subject: Re: XFS leadership and a new co-maintainer candidate
Message-ID: <20131108212909.GT30145@boogeyman>
References: <mailman.2046.1383942763.4413.xfs@oss.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <mailman.2046.1383942763.4413.xfs@oss.sgi.com>
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
To: xfs@oss.sgi.com

On Fri, Nov 08, 2013 at 06:03:41AM -0500, Ric Wheeler wrote:
> In the XFS community, we have 2 clear leaders in terms of
> contributions of significant feaures and depth of knowledge -
> Christoph and Dave.
> 
> If you look at the number of patches submitted by developers since
> 3.0 who have more than 10 patches, we get the following:
> 
>     319 Author: Dave Chinner <dchinner@redhat.com>
>     163 Author: Christoph Hellwig <hch@infradead.org>
>      51 Author: Christoph Hellwig <hch@lst.de>
>      35 Author: Linus Torvalds <torvalds@linux-foundation.org>
>      34 Author: Chandra Seetharaman <sekharan@us.ibm.com>
>      29 Author: Al Viro <viro@zeniv.linux.org.uk>
>      28 Author: Brian Foster <bfoster@redhat.com>
>      25 Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>      24 Author: Jeff Liu <jeff.liu@oracle.com>
>      21 Author: Jie Liu <jeff.liu@oracle.com>
>      20 Author: Mark Tinguely <tinguely@sgi.com>
>      16 Author: Dave Chinner <david@fromorbit.com>
>      12 Author: Eric Sandeen <sandeen@redhat.com>
>      12 Author: Carlos Maiolino <cmaiolino@redhat.com>
> 
> If we as a community had more capacity for patch review, Dave's
> numbers would have jumped up even higher :)
> 
> It is certainly very welcome to bring new developers into our
> community, but if we are going to add a co-maintainer for XFS, we
> really need to have one of our two leading developers in that role.

I don't have a dog in this fight, so I'm going to give my opinion on the
matter.  You guys can fight it out.

I'm not really sure why amount of code contributed implies good
maintainership.  Over our professional lives, I'm sure that we've worked
with a lot of people who couldn't write code worth beans who maintained
the source competently.

I'm not sure why the title is being bandied about as an honorific.  It's
not the America's Cup and having a title passed around because of a particular
metric seems counterproductive.

Ben has obvious -- and good -- reasons for choosing Mark.  Not only does
he have an office right nearby, but Mark has done excellent work and he's been
pretty enthusiastic while doing it.

To my mind, easy access to co-maintainers implies that it's a lot easier to
share knowledge and coordinate -- isn't that where the "co-" part of
"co-maintainer" comes from?

It's expected that some people are going to be in different time zones in an
open source project.  But as I'm sure we can all attest, it's a bear to
coordinate with people who are a great many hours off from your time zone.

If I remember correctly, Dave's in Australia and Christoph's in Germany.  If
we're going to have a small number of maintainers, I can see the logic in
having them be on the same continent and within a few time zones.

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
