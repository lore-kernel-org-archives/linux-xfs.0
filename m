Date: Wed, 19 Oct 2016 14:06:27 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20161019120626.GI7517@dhcp22.suse.cz>
References: <20160516132541.GP3193@twins.programming.kicks-ass.net>
 <20160516231056.GE18496@dastard>
 <20160517144912.GZ3193@twins.programming.kicks-ass.net>
 <20160517223549.GV26977@dastard>
 <20160519081146.GS3193@twins.programming.kicks-ass.net>
 <20160520001714.GC26977@dastard>
 <20160601131758.GO26601@dhcp22.suse.cz>
 <20160601181617.GV3190@twins.programming.kicks-ass.net>
 <20161006130454.GI10570@dhcp22.suse.cz>
 <20161019083304.GD3102@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161019083304.GD3102@twins.programming.kicks-ass.net>
List-ID: <xfs.oss.sgi.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, xfs@oss.sgi.com, linux-mm@kvack.org, Ingo Molnar <mingo@kernel.org>

On Wed 19-10-16 10:33:04, Peter Zijlstra wrote:
[...]
> So I'm all for this if this works for Dave.
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Thanks Peter!

> Please take it through the XFS tree which would introduce its first user
> etc..

Dave, does that work for you? I agree that having this followed by a
first user would be really preferable. Maybe to turn some of those added
by b17cb364dbbb? I wish I could help here but as you've said earlier
each such annotation should be accompanied by an explanation which I am
not qualified to provide.
-- 
Michal Hocko
SUSE Labs
