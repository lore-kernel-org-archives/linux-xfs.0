Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C3447CAE
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 14:00:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CDB8FAC001
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 12:00:35 -0700 (PDT)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	CotQne81GpDioEgA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 11:59:54 -0700 (PDT)
Received: by mail-io0-f170.google.com with SMTP id m184so220501645iof.1
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 11:59:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160321020505.GJ11812@dastard>
References: <20160321020505.GJ11812@dastard>
Date: Mon, 21 Mar 2016 11:59:54 -0700
Message-ID: <CA+55aFy4NNR+VUD=KpLE=vMz22xrQ7E5J8A_B-Pf4Hj8GjBVFQ@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: updates for 4.6-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sun, Mar 20, 2016 at 7:05 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> There are conflicts with the ext4 code that has already been merged
> this cycle.

The merge looked pretty straightforward, but both of you (ie both the
xfs and ext4 people, please) should check the end result please.

My sanity-check is still building, but it should be all pushed out in
another 15 minutes or so.

             Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
