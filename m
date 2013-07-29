Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E914C7F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 11:56:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 639F4AC003
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 09:56:04 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	9m0fkwGSI29EU4nt for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 09:55:59 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id DB53D1F005BE
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 12:55:58 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id dg1YwExBDjf9 for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 12:55:55 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 26CA51F004A4
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 12:55:55 -0400 (EDT)
Date: Mon, 29 Jul 2013 12:55:55 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <7514012.2548.1375116955021.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <51F69340.2040606@mrc-lmb.cam.ac.uk>
Subject: Re: [Fwd: Re: A short digression on FOSS (Re: understanding
	speculative	preallocation)]
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Please do not move private replies back on list without permission;
that's been poor mailing list etiquette since at least 1982.

I'm *officially* done now; Dave: your partisans are cranks, and you need
to get them in hand.

Cheers,
-- jra

----- Original Message -----
> From: "Dave Howorth" <dhoworth@mrc-lmb.cam.ac.uk>
> To: xfs@oss.sgi.com
> Sent: Monday, July 29, 2013 12:07:28 PM
> Subject: [Fwd: Re: A short digression on FOSS (Re: understanding speculative preallocation)]
> Please keep the conversation on list
> 
> To me now it sounds like you're just trolling, though I suspect you
> don't intend that. I really do suggest you take some time to forget
> about this topic and come back to it in a few days with a clear head
> and
> reread it all. Then decide whether it's worth pursuing.
> 
> -------- Original Message --------
> Subject: Re: A short digression on FOSS (Re: understanding speculative
> preallocation)
> Date: Mon, 29 Jul 2013 11:36:29 -0400 (EDT)
> From: Jay Ashworth <jra@baylink.com>
> To: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
> 
> [ off list ]
> 
> ----- Original Message -----
> > From: "Dave Howorth" <dhoworth@mrc-lmb.cam.ac.uk>
> 
> > So the easiest way for a non-expert to describe the kernel they're
> > using
> > is most likely to name a distro and release, plus whatever updates
> > have
> > been applied. A distro-expert can translate that into the general
> > age of
> > the code and the commit numbers of the exact patches that have been
> > applied if necessary. And that's why the FAQ
> >
> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >
> > asks people to report the uname -a amongst a lot of other stuff.
> 
> That's all well and good, Dave, but I've spent the last 72 hours with
> Stan
> tearing my face off precisely over his assertion that *the experts in
> question won't be interested in doing that*: it should be *my*
> responsiility.
> 
> If they're going to make us do the work -- and this seems the
> assertion
> Stan,
> Eric and others are making, pretty vehemently -- they need to give us
> *an
> end game*; a question to be asking. Or researching.
> 
> The specific issue was "we don't like CentOS cause we work for RH and
> they
> ripped us off". Aside from "if you think they ripped you off, then you
> don't understand FOSS well enough to be making money from it", *the
> CentOS
> kernel package names are the exact same as the RHEL packages*; CentOS
> makes
> a point of this being true because modules have to match up.
> 
> So that seems like a red herring too.
> 
> The short version of this is:
> 
> We're trying to help them to help us, and they seem to be making that
> as
> difficult as humanly possible, and I can't understand why.
> 
> As I said: if the kernel builder is checking out a GIT pull to build
> the
> modules for a given kernel SRPM, than that's what I *expect* Dave et
> al
> to want to know, and I can deal with go getting that number somehow.
> 
> But why won't anyone actually *say* that?
> 
> Cheers,
> -- jra
> --
> Jay R. Ashworth Baylink
> jra@baylink.com
> Designer The Things I Think
> RFC 2100
> Ashworth & Associates http://baylink.pitas.com 2000 Land
> Rover DII
> St Petersburg FL USA #natog +1 727
> 647 1274
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
