Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42710 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729907AbfGAOy0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Jul 2019 10:54:26 -0400
Subject: Re: [linux-kernel-mentees] [PATCH v1] Doc : fs : convert xfs.txt to
 ReST
References: <20190630165046.GB5193@localhost>
 <20190630113243.7265c33e@lwn.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7251234a-9469-68a6-8a23-c023bd01c637@sandeen.net>
Date: Mon, 1 Jul 2019 09:54:23 -0500
MIME-Version: 1.0
In-Reply-To: <20190630113243.7265c33e@lwn.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jonathan Corbet <corbet@lwn.net>, Sheriff Esseson <sheriffesseson@gmail.com>
Cc: skhan@linuxfoundation.org, linux-kernel-mentees@lists.linuxfoundation.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org



On 6/30/19 12:32 PM, Jonathan Corbet wrote:
> On Sun, 30 Jun 2019 17:50:46 +0100
> Sheriff Esseson <sheriffesseson@gmail.com> wrote:
> 
>> On Sat, Jun 29, 2019 at 09:57:59PM +0100, Sheriff Esseson wrote:
>>> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
>>> ---
>>>
>>> In v3:
>>> Update MAINTAINERS. Fix Indentation/long line issues. Insert Sphinx tag.
>>>
>>> -- 
>>> 2.22.0
>>>   
>>
>> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
>> ---
>>
>> In v4:
>> dax.txt : 
>> 	fix broken reference to xfs.rst
> 
> I will now repeat what I said yesterday:
> 
>> Please do us a favor?  
>>
>> 1) Post each patch standalone, without quoted text, ready to be applied.

To be maybe more explicit,

While we appreciate the eagerness here I'd like to reiterate that the
followup V2, V3, ... patches should each be a standalone, self-contained
email, without any quoted text and with updated subject lines, i.e.

Subject: [PATCH] Doc : fs : convert xfs.txt to ReST

followed by:

Subject: [PATCH V2] Doc : fs : convert xfs.txt to ReST

followed by:

Subject: [PATCH V3] Doc : fs : convert xfs.txt to ReST

so it's trivial to see from subject lines when a new version has been
sent.

Also, what Jonathan said about time between iterations.  ;)

Thanks,
-Eric


>> 2) Wait a little while between postings so that you can address more than
>> one comment at a time.
>>
>> OK, two favors - off-by-one errors are my specialty...:)
> 
> I did actually mean that.  For "a little while" I meant "a few days or
> so".  Please slow down a little.  In any case, we're getting closer to the
> merge window, so this patch won't be applied for a while regardless.
> 
> Thanks,
> 
> jon
> 
