Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E108C7F53
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 04:28:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 872A0304043
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 02:28:51 -0800 (PST)
Received: from mail-vk0-f54.google.com (mail-vk0-f54.google.com
	[209.85.213.54]) by cuda.sgi.com with ESMTP id X63o1pnXDHiErEGa
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Feb 2016 02:28:40 -0800 (PST)
Received: by mail-vk0-f54.google.com with SMTP id c3so156783613vkb.3
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 02:28:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56CC3174.2060207@gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
	<CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
	<56C0F23C.7030902@gmail.com>
	<CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A@mail.gmail.com>
	<56CA2EEB.9080504@gmail.com>
	<CAHc6FU46vO8NM3cvFH7b8X7U9R+m6wcYj8EQKVnSQkiY3Q051A@mail.gmail.com>
	<56CC3174.2060207@gmail.com>
Date: Tue, 23 Feb 2016 11:28:39 +0100
Message-ID: <CAHc6FU60f4Hnd7CzAxTKRMjiKPUWn6QqM3LGRmJg59sLX1OscQ@mail.gmail.com>
Subject: Re: richacl(7) man page review comments
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, lkml <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Feb 23, 2016 at 11:16 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> On 02/22/2016 03:46 PM, Andreas Gruenbacher wrote:
>> On Sun, Feb 21, 2016 at 10:40 PM, Michael Kerrisk (man-pages) <mtk.manpages@gmail.com> wrote:
>>> Could we start with just a few simple examples already, and build up
>>> over future iterations of this page?
>>
>> Yes, as soon as I'll get to it :)
>
> Sure. But, to press the point home, I'm interested to do further
> review, but I feel like the lack of examples is limiting my ability to
> understand what's going on and deepen the feedback that I provide in
> future iterations. So, start please, even if only starting small :-).

Sure, I understand that.

In case you didn't stumble upon this page before, a few very simple
examples showing how things interact can be found here:

  http://www.bestbits.at/richacl/examples.html

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
