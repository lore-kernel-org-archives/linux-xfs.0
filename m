Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o18I0ZEn150687 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 12:00:35 -0600
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46E3C1CB1484
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 10:01:47 -0800 (PST)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id LfUuInnnulTtWEvc
	for <xfs@oss.sgi.com>; Mon, 08 Feb 2010 10:01:47 -0800 (PST)
Received: by vws10 with SMTP id 10so1569798vws.26
	for <xfs@oss.sgi.com>; Mon, 08 Feb 2010 10:01:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100125042925.GM25842@discord.disaster>
References: <20100125150456.c796f0b0.sfr@canb.auug.org.au>
	<20100125042925.GM25842@discord.disaster>
Date: Mon, 8 Feb 2010 13:01:46 -0500
Message-ID: <7e0fb38c1002081001y111bd0a2p40a8a896b0668d13@mail.gmail.com>
Subject: Re: linux-next: vfs/fsnotify trees build warning
From: Eric Paris <eparis@parisplace.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>, xfs@oss.sgi.com, linux-next@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Sun, Jan 24, 2010 at 11:29 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Jan 25, 2010 at 03:04:56PM +1100, Stephen Rothwell wrote:
>> Hi Eric, Al,
>>
>> Today's linux-next build (x86_64 allmodconfig) produced these warnings:

I just switched fsnotify to use const unsigned char * so hopefully
they will shut up tomorrow....

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
