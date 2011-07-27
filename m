Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RGS72a211877 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 11:28:07 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D568C52CE33
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 09:28:06 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [72.73.18.11]) by cuda.sgi.com
	with ESMTP id HiEcVSXRiQDHOgYA for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 09:28:06 -0700 (PDT)
Date: Wed, 27 Jul 2011 12:28:05 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
In-Reply-To: <20110727160752.GC974@fieldses.org>
Message-ID: <alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<20110727160752.GC974@fieldses.org>
MIME-Version: 1.0
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Wed, 27 Jul 2011, J. Bruce Fields wrote:

> On Wed, Jul 27, 2011 at 09:54:09AM -0400, Justin Piszcz wrote:
>> Hi,
>>
>> Kernel 2.6.30 on client.
>> Kernel 2.6.28 on server.
>>
>> p34 kernel: [92223.918892] NFS: directory motion/cam2 contains a
>> readdir loop.  Please contact your server vendor.  Offending cookie: 10272
>
> What filesystem on the server are you exporting?

Hi,

xfs.
/dev/sda1 on / type xfs (rw,noatime)

Nothing special, thoughts?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
