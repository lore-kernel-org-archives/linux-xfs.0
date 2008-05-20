Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 12:29:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4KJTOHu025405
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 12:29:25 -0700
Message-ID: <483326AE.3040902@thebarn.com>
Date: Tue, 20 May 2008 14:29:50 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: take messages
References: <20080518102710.GA17618@lst.de> <4830CA28.9060805@sgi.com> <20080519060022.GA15529@lst.de> <48322E58.8060009@sgi.com> <20080520102012.GB24579@infradead.org> <4832B868.7050001@sgi.com>
In-Reply-To: <4832B868.7050001@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Mark Goodwin wrote:
>
>
> Christoph Hellwig wrote:
>> On Tue, May 20, 2008 at 11:50:16AM +1000, Lachlan McIlroy wrote:
>>> oss pushes automatic?  They could be but aren't.
>>
>> They aren't?  Back in the days the CVS tree on OSS was updated from
>> ptools once a day.
>>
>
> The ptools->cvs push is automatic. The git updates are not.
> We have a plan to fix that ... just catching our breath a bit
> at the moment.
ptools to oss cvs is done once every hour.
Which is probably a bit silly now given updates come from the CA ptools 
server
and most XFS commits probably originate at the AU server. If I recall 
correctly
the AU <-> CA ptools sync is only once a day.

There is also the xfs git and the dmapi git trees that are auto synced 
with the
cvs tree once a day.  (minus the autoversion stuff)
>
> Cheers
>
