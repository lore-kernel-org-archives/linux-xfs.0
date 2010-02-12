Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CH3b3D006914 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 11:03:37 -0600
Received: from mail-ew0-f227.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 180AB1CC76D8
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 09:04:52 -0800 (PST)
Received: from mail-ew0-f227.google.com (mail-ew0-f227.google.com
	[209.85.219.227]) by cuda.sgi.com with ESMTP id
	6OUt3If1EbdKTZNm for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2010 09:04:52 -0800 (PST)
Received: by ewy27 with SMTP id 27so2804080ewy.18
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 09:04:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100212165801.GA7323@puku.stupidest.org>
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>
	<20100212165801.GA7323@puku.stupidest.org>
Date: Fri, 12 Feb 2010 18:04:51 +0100
Message-ID: <2d460de71002120904n346b1b1n307a07a3dd4d9@mail.gmail.com>
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
From: Richard Hartmann <richih.mailinglist@gmail.com>
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
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

On Fri, Feb 12, 2010 at 17:58, Chris Wedgwood <cw@f00f.org> wrote:

> try adding -P

Which leads me to the question if it would be save to just CTRL-C a
running xfs_repair (or if there is a different graceful shutdown function).

In any case, I would then retry with 3.1.0/3.1.1.


Thanks,
Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
