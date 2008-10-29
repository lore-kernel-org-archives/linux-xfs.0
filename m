Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 18:03:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T12nAq019453
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 18:02:50 -0700
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBC9414A0730
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 18:02:49 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202]) by cuda.sgi.com with ESMTP id rlsHfVGYWu6ENmEc for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 18:02:49 -0700 (PDT)
Received: from funky.thebarn.com (slurp.thebarn.com [208.42.117.201])
	(authenticated bits=0)
	by slurp.thebarn.com (8.14.0/8.13.8) with ESMTP id m9T12fCS035694;
	Tue, 28 Oct 2008 20:02:41 -0500 (CDT)
	(envelope-from cattelan@xfs.org)
Message-ID: <4907B631.1090205@xfs.org>
Date: Tue, 28 Oct 2008 20:02:41 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: oss.sgi.com and mailman, looking for volunteers.
References: <490720DD.2050502@thebarn.com> <20081028215031.GY4985@disturbed> <20081028223053.GA458@infradead.org>
In-Reply-To: <20081028223053.GA458@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Oct 29, 2008 at 08:50:31AM +1100, Dave Chinner wrote:
>   
>> What is the point? Let's just move the list to vger.kernel.org and
>> we can forget about all these problems....
>>     
>
> Yeah.  ecartis is just part of the problem.  barracuda is another at
> least as big problem, and I guess there are many other hiding.
>
>   
ya it has dropped 39 messages this month
oss[5:59pm]#formail -x Subject: -s < xfs.2008-10 |wc -l
741
oss[5:59pm]#formail -x Subject: -s < xfs-procmail-2008_10  | wc -l
780


I think using mailman will clear up the dropped mail problems.

What other issues do you think is there?

The barracuda problem is outside of oss and affects all mail from 1st.de 
to sgi.

Did you ever find out why barracuda thinks your ip has  a "poor" rating?
