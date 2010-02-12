Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CHBqxA007668 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 11:11:52 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FADD13A3514
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 09:13:06 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id KWyPHcnDFTbz0fxc for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2010 09:13:06 -0800 (PST)
Message-ID: <4B758C22.5050102@sandeen.net>
Date: Fri, 12 Feb 2010 11:13:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>	<20100212165801.GA7323@puku.stupidest.org>
	<2d460de71002120904n346b1b1n307a07a3dd4d9@mail.gmail.com>
In-Reply-To: <2d460de71002120904n346b1b1n307a07a3dd4d9@mail.gmail.com>
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
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com

Richard Hartmann wrote:
> On Fri, Feb 12, 2010 at 17:58, Chris Wedgwood <cw@f00f.org> wrote:
> 
>> try adding -P
> 
> Which leads me to the question if it would be save to just CTRL-C a
> running xfs_repair (or if there is a different graceful shutdown function).

It is safe, as the manpage says right there by the -P option ;)

-Eric

> In any case, I would then retry with 3.1.0/3.1.1.
> 
> 
> Thanks,
> Richard
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
