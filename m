Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 18:42:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K1gPId000770
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 18:42:27 -0700
Message-ID: <48322D15.3050201@sgi.com>
Date: Tue, 20 May 2008 11:44:53 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: take messages
References: <20080518102710.GA17618@lst.de> <4830CA28.9060805@sgi.com>
In-Reply-To: <4830CA28.9060805@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Mark Goodwin wrote:
> 
> 
> Christoph Hellwig wrote:
>> folks, any chance to get take messages sent to the list, please? 
> 
> do you mean for any checkin, or just oss pushes?
> 
>> Kust
>> saw the tree is merged up to 2.6.25 (why not .26-rc, btw?) and there's
>> been no take message sent to the list again..
>>
> 
> Lachlan was held up with QA failures on updating the internal dev tree,
> which was in turn holding up .26-rc I think.
> 
> Lachlan, what's the status with this?

It was a big TAKE message so it was probably dropped on the floor
somewhere.

Updates to the internal dev tree are dependent on the kdb patches
and at the time they were only available for 2.6.26-rc1.  2.6.25
was a more stable choice.  We usually wait until -rc3 for an update
so as soon as the kdb patches are available I'll do another merge.
