Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAE8xExV055193 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 02:59:14 -0600
Received: from galenis.iv.lt (galenis.iv.lt [195.14.170.242]) by cuda.sgi.com
	with ESMTP id AB3X7rHAvKnngIC0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Nov 2012 01:01:16 -0800 (PST)
Message-ID: <50A35DD8.801@iv.lt>
Date: Wed, 14 Nov 2012 11:01:12 +0200
From: Linas Jankauskas <linas.j@iv.lt>
MIME-Version: 1.0
Subject: Re: Slow performance after ~4.5TB
References: <50A0AFD5.2020607@iv.lt> <20121112090448.GS24575@dastard>
	<50A0C590.6020602@iv.lt> <20121112123222.GT24575@dastard>
	<50A10077.2060908@iv.lt> <20121112223623.GV24575@dastard>
	<50A20F53.80405@iv.lt> <20121113195026.GH25039@dastard>
In-Reply-To: <20121113195026.GH25039@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

I made new smaller report with only one rsync proccess running. Here it 
is http://www63.zippyshare.com/v/42810808/file.html


Linas

On 11/13/2012 09:50 PM, Dave Chinner wrote:
> On Tue, Nov 13, 2012 at 11:13:55AM +0200, Linas Jankauskas wrote:
>> trace-cmd output was about 300mb, so im pasting first 100 lines of
>> it, is it enough?:
>
> Not, compress it (it'll compress well) and post a link for me to
> download or send it directly to me.
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
