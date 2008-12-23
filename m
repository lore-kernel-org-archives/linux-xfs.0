Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBNEp3a8026431 for <xfs@oss.sgi.com>; Tue, 23 Dec 2008 08:51:06 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1CBC426E1
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2008 06:50:58 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id NTZhopCbYuBlP2Fo for
	<xfs@oss.sgi.com>; Tue, 23 Dec 2008 06:50:58 -0800 (PST)
Date: Tue, 23 Dec 2008 09:50:26 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.27.10: cannot mount xfs filesystem partition (12TiB) after
	reboot
In-Reply-To: <20081223134247.GA17750@infradead.org>
Message-ID: <alpine.DEB.1.10.0812230950120.7572@p34.internal.lan>
References: <alpine.DEB.1.10.0812230829420.4817@p34.internal.lan>
	<20081223134247.GA17750@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
Cc: linux-raid@vger.kernel.org, bug-parted@gnu.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Tue, 23 Dec 2008, Christoph Hellwig wrote:

> On Tue, Dec 23, 2008 at 08:36:17AM -0500, Justin Piszcz wrote:
>> Kernel = 2.6.27.10
>> Parted = 1.8.8.git.2008.03.24-11.1
>>
>> Can anyone help explain the problem here?
>
> Can you post your kernel .config file?
>

http://home.comcast.net/~jpiszcz/20081223/config-2.6.27.10.txt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
