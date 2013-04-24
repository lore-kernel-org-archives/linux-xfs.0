Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D33FD29DFA
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 12:32:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1B6E304070
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 10:32:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iBGi075pw0s7JPTR for
	<xfs@oss.sgi.com>; Wed, 24 Apr 2013 10:32:13 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3OHWDvX024464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 13:32:13 -0400
Received: from [10.3.113.131] (ovpn-113-131.phx2.redhat.com [10.3.113.131])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r3OHWCiK013732
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 13:32:13 -0400
Message-ID: <5178171C.7060109@redhat.com>
Date: Wed, 24 Apr 2013 13:32:12 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: XFS Support in RHEL Server 6.4 x86_64
References: <5177B899.4000707@dermichi.com>
	<CANXjJiac95ud6rYpRCvtMLQv6kTHFHNd0U1rzes3NVtQA=J8ZA@mail.gmail.com>
In-Reply-To: <CANXjJiac95ud6rYpRCvtMLQv6kTHFHNd0U1rzes3NVtQA=J8ZA@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 04/24/2013 11:00 AM, James Braid wrote:
>
> On 24 April 2013 11:48, Michael Weissenbacher <mw@dermichi.com 
> <mailto:mw@dermichi.com>> wrote:
>
>     But the big question now is: can anybody actually recommend using XFS on
>     stock RHEL? It does feel like being just a stepchild there. On the other
>     hand there seem be be quite a number of patches that were backported for
>     Red Hat's kernel and it does use delaylog by default (which IIRC wasn't
>     the default with a stock 2.6.32 Kernel).
>
>
> It's an addon product and not supported as a root filesystem on RHEL 6:
>
> http://www.redhat.com/products/enterprise-linux-add-ons/file-systems/
>
> A number of the XFS developers are employed by Red Hat...
>
>

And it is the only file system in RH Storage (gluster) that we support and quite 
popular with normal RHEL users as well.

Definitely not ignored in any way.

If you have questions about how to get it, let me know.

Regards,

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
