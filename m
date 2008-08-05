Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 18:36:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m751aeLk024659
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 18:36:41 -0700
Message-ID: <4897B05A.7040002@sgi.com>
Date: Tue, 05 Aug 2008 11:43:54 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [rfc][patch 3/3] xfs: use new vmap API
References: <20080728123438.GA13926@wotan.suse.de> <20080728123703.GC13926@wotan.suse.de> <4896A197.3090004@sgi.com> <200808042057.20607.nickpiggin@yahoo.com.au>
In-Reply-To: <200808042057.20607.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Nick Piggin <npiggin@suse.de>, Linux Memory Management List <linux-mm@kvack.org>, xfs@oss.sgi.com, xen-devel@lists.xensource.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.sourceforge.net

Okay.  When the time comes will you push the XFS changes to mainline
or would you like us to?

Nick Piggin wrote:
> Thanks for taking a look. I'll send them over to -mm with patch 1,
> then, for some testing.
> 
> On Monday 04 August 2008 16:28, Lachlan McIlroy wrote:
>> Looks good to me.
>>
>> Nick Piggin wrote:
>>> Implement XFS's large buffer support with the new vmap APIs. See the vmap
>>> rewrite patch for some numbers.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
