Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o86IaLUS192818 for <xfs@oss.sgi.com>; Mon, 6 Sep 2010 13:36:22 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 122D515DFFA9
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 11:48:06 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id ANziJotYdheKaZxq
	for <xfs@oss.sgi.com>; Mon, 06 Sep 2010 11:48:06 -0700 (PDT)
Received: by fxm15 with SMTP id 15so2777637fxm.26
	for <xfs@oss.sgi.com>; Mon, 06 Sep 2010 11:37:02 -0700 (PDT)
Message-ID: <4C8534D0.3050003@googlemail.com>
Date: Mon, 06 Sep 2010 20:37:04 +0200
From: Marcus Osdoba <marcus.osdoba@googlemail.com>
MIME-Version: 1.0
Subject: Re: xfs on armv5 still with erroneous log in kernel 2.6.35.4
References: <4C835A34.9080008@googlemail.com> <20100906005230.GX7362@dastard>
	<4C845EDE.3010806@sandeen.net>
In-Reply-To: <4C845EDE.3010806@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

  Am 06.09.2010 05:24, schrieb Eric Sandeen:
>
> I do, and owe their donors some testing; if this is still failing
> on a kernel with the vipt stuff in place I'll haul them out and
> do some testing..
>
> -Eric
Hi Eric,
Thank you both for your ansers.

I'm using the latest stable kernel 2.6.35.4. The filesystem was created 
on the target device with a cross compiled xfsprogs 3.1.3.
The systems runs on an armv5te architecture (sheevaplug derivative). 
After creating, mounting and writing some data on it, re-mounting was 
not possible with the above mentioned error. I've found this message in 
the mailinglistarchive and thought the patches were integrated into 
mainline.

How can I help? What additional information do you need?

regards,
Marcus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
