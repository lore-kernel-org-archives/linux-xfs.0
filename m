Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p513Q5XA090695 for <xfs@oss.sgi.com>; Tue, 31 May 2011 22:26:05 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B92ED1E396C2
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 20:26:04 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id 34AOAPXTY8ZMYGuI
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 20:26:04 -0700 (PDT)
Received: by wyi11 with SMTP id 11so4402472wyi.26
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 20:26:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110531202926.GA17246@infradead.org>
References: <BANLkTimjBe5gmgObaG9j8SiD3mj9RxaSaw@mail.gmail.com>
	<20110531202926.GA17246@infradead.org>
Date: Wed, 1 Jun 2011 06:26:03 +0300
Message-ID: <BANLkTimvXEd-7ZezUt2ZME0HEuNYHASbsg@mail.gmail.com>
Subject: Re: [PATCH] fix hardcoded reference to /mnt/test in common.attr
From: Amir Goldstein <amir73il@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, sergey ivanov <sergey57@gmail.com>, XFS <xfs@oss.sgi.com>

On Tue, May 31, 2011 at 11:29 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Thanks, applied.
>
> (after fixing whitespace damage in the patch)

Sorry about those... I usually get away with copy&paste of a single patch
to gmail.
it works with kernel coding convention of tab indentation and short lines,
but xfstests appear to have some space indentations and long lines,
so it doesn't go that well.
I apologize in advance for the other damaged patch already sent out
(ext4dev FSTYP support)

>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
