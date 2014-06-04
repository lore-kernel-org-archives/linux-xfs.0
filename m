Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8CE6E7F3F
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 14:14:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79217304081
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 12:14:36 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zSksEj3u6gqnZPJX for <xfs@oss.sgi.com>;
	Wed, 04 Jun 2014 12:14:33 -0700 (PDT)
Message-ID: <538F701C.8040702@sandeen.net>
Date: Wed, 04 Jun 2014 14:14:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Why xfs is not permitted on bootable partitions in RHEL 7?
References: <CAMqKDv6Ki0vxBkbAJFyZ19C0SqBihSc6kii8cjagtOFF7ECi5A@mail.gmail.com>
In-Reply-To: <CAMqKDv6Ki0vxBkbAJFyZ19C0SqBihSc6kii8cjagtOFF7ECi5A@mail.gmail.com>
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
To: Dhiraj Bhor <dhirajbhor21@gmail.com>, xfs@oss.sgi.com

On 6/4/14, 12:33 PM, Dhiraj Bhor wrote:
> Hi all,
> I am new to this mailing list. I came across a issue with xfs while installing RHEL 7.

Then it's probably a question best left to your RHEL7 support folks...

> When I created "custom layout" and created /boot partition with xfs file system it shown me error as "/boot filesystem cannot be of type xfs".
> Why xfs is not allowed on /boot partition?
> Help me resolving this issue.

... but AFAIK that is supposed to work; it sounds like a bug if it's prohibited - perhaps you can either let your support folks know, or file a bug @ RH bugzilla.

Thanks,
-Eric

> Thanks,
> Dhiraj
> 
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
