Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4D3HWL030071 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 07:03:17 -0600
Received: from rv-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95ED116938BC
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 05:03:16 -0800 (PST)
Received: from rv-out-0506.google.com (rv-out-0506.google.com
	[209.85.198.225]) by cuda.sgi.com with ESMTP id
	9rqoeNJCcCXiCBnB for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 05:03:16 -0800 (PST)
Received: by rv-out-0506.google.com with SMTP id f9so3925799rvb.7
	for <xfs@oss.sgi.com>; Thu, 04 Dec 2008 05:03:15 -0800 (PST)
Message-ID: <416c461f0812040503g13083bdbl7a9b716f17d2adc0@mail.gmail.com>
Date: Fri, 5 Dec 2008 00:03:15 +1100
From: "Niv Sardi" <xaiki@cxhome.ath.cx>
Subject: Re: [patch 01/22] fix compile on 32 bit systems
In-Reply-To: <20081204123432.GC7085@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160649.658660000@bombadil.infradead.org>
	<87vdu07nvp.fsf@cxhome.ath.cx> <20081204123432.GC7085@infradead.org>
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
Cc: xfs@oss.sgi.com

Oh well, lachland allready checked it in like that...

On Thu, Dec 4, 2008 at 11:34 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Dec 04, 2008 at 12:03:22PM +1100, Niv Sardi wrote:
>> Christoph Hellwig <hch@infradead.org> writes:
>> [???]
>> > +xfs_file_compat_ioctl_invis(
>>                    ^^^^^^^^^^^
>> [???]
>> > -extern long xfs_file_compat_invis_ioctl(struct file *, unsigned, unsigned long);
>>                                ^^^^^^^^^^^
>>
>> Fixed it up, it's in QA now,
>
> Doh, thanks.
>
>



-- 
Niv Sardi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
